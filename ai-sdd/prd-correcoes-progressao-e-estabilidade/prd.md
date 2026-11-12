# PRD - Correções Críticas de Progressão, Segurança de Gameplay e Estabilidade

## Visão Geral

Durante a auditoria técnica completa e os testes práticos de homologação do **Game QTA**, identificou-se um conjunto de falhas funcionais, brechas de autorização no backend e inconsistências de interface que impedem o funcionamento pleno da regra central do jogo: **a progressão entre níveis mediante aproveitamento mínimo de 70%**.

Embora o cálculo de fim de nível exiba a tela de aprovação (*"Nível Concluído!"*), a tela principal **"Sua Jornada"** (`dashboard/index.html.erb`) verificava apenas `level.starting_level?` (fixado no primeiro nível do banco), mantendo os Níveis 2 a 5 permanentemente bloqueados na interface. Paralelamente, a versão auditada em `main` carecia de travas para impedir o início de níveis bloqueados via requisição direta, a conclusão prematura de temas sem responder questões e a dessincronização do Ranking Global quando níveis são reprovados/resetados.

Este PRD consolida todas as correções estruturais necessárias para garantir que o ciclo de gameplay, o ranking e o painel administrativo operem com integridade ponta a ponta.

## Objetivos

- **Objetivo 1 (Progressão Real de Níveis):** Garantir que, ao concluir todos os temas de um nível com aproveitamento $\ge 70\%$ sobre o total de questões do nível, o próximo nível seja efetivamente desbloqueado na tela "Sua Jornada" e no backend.
- **Objetivo 2 (Blindagem do Motor de Gameplay):** Impedir bypass de níveis bloqueados via `POST /play/themes/:id/start`, conclusão prematura via `GET /play/themes/:id/finish` com questões pendentes e aprovação de nível sem concluir todos os temas e questões.
- **Objetivo 3 (Consistência do Ranking Global):** Recalcular o `Leaderboard` sempre que tentativas ou submissões forem destruídas (reprovação de nível ou reinício de tema) e manter `users.total_score` e `question_submissions.score` sincronizados.
- **Objetivo 4 (Integridade do Painel Administrativo e Segurança):** Adicionar validações completas no model `Admin` (evitando erro 500 por e-mail vazio/duplicado), corrigir o feedback de exclusão de `Level` com temas associados, corrigir a métrica de temas concluídos no Dashboard Admin e sanitizar exportações CSV contra *Formula Injection*.
- **Objetivo 5 (Qualidade de Interface, I18n e Higiene do Repositório):** Mapear as ilustrações `ods-1.png` a `ods-5.png` pela posição sequencial do nível (e não pelo ID primário do banco), exibir a inicial real do estudante no avatar, remover scripts órfãos da raiz, traduzir mensagens em inglês e estabilizar a suíte `bin/rails test:system`.

## Histórias de Usuário

- Como **Estudante**, eu quero que o Nível 2 (e os subsequentes) seja desbloqueado automaticamente na tela "Sua Jornada" assim que eu concluir todos os temas do Nível anterior com pelo menos 70% de acertos no total de questões do nível, para continuar avançando no jogo.
- Como **Estudante**, eu quero visualizar claramente na "Sua Jornada" quais níveis e temas já concluí e qual está em progresso, além de ver as ilustrações corretas de cada nível mesmo após recriação do banco de dados.
- Como **Educador / Gestor**, eu quero que nenhum estudante consiga pular níveis bloqueados ou finalizar temas sem responder a todas as perguntas pela URL, garantindo a validade pedagógica e competitiva do jogo.
- Como **Administrador**, eu quero receber mensagens claras de erro caso tente excluir um Nível que possui Temas ou cadastrar um administrador com dados inválidos, sem enfrentar telas de erro 500 ou mensagens falsas de sucesso.

## Requisitos Funcionais

### 1. Motor de Progressão e Desbloqueio de Níveis
- **RF-001**: Um `Theme` só é considerado concluído pelo estudante (`completed_by?(user)`) quando existir um `ThemeAttempt` com `status: :completed` para aquele usuário e todas as questões do tema tiverem sido respondidas nessa tentativa.
- **RF-002**: O cálculo `Level#score_for(user)` deve dividir o total de respostas corretas (nas tentativas concluídas mais recentes de cada tema do nível) pelo **total de questões existentes no nível** (`Question.where(theme_id: themes.select(:id)).count`), retornando `0.0` caso o nível não possua questões.
- **RF-003**: Um `Level` é considerado aprovado (`passed_by?(user)`) quando possuir temas, **todos os seus temas** estiverem concluídos pelo estudante (`completed_by?(user)`) e o número de acertos satisfizer `acertos * 100 >= total_questões * 70`, sem usar a nota arredondada.
- **RF-004**: Um `Level` é considerado desbloqueado (`available_to?(user)`) quando for o primeiro nível (`starting_level?`) **ou** quando todos os níveis anteriores na ordem de `id` estiverem aprovados.
- **RF-005**: A operação `ThemeAttempt#complete`, acionada por `Play::ThemeCompletionsController#create`, deve avaliar a aprovação/reprovação do nível sempre que o estudante concluir o último tema que faltava para completar todos os temas daquele nível (independentemente da ordem em que jogou os temas do nível). Se todos os temas do nível estiverem concluídos e `passed_by?(user)` for falso, o progresso do nível é resetado (`reset_progress_for`).

### 2. Blindagem e Anti-Bypass no Backend de Gameplay
- **RF-006**: `Play::ThemeAttemptsController#create` deve chamar `Current.user.start_theme`, validando a disponibilidade do nível e retomando uma tentativa ativa sem apagar respostas. Caso contrário, deve redirecionar para `jornada_path` com alerta de nível bloqueado, sem criar `ThemeAttempt`.
- **RF-007**: `Play::ThemeCompletionsController#create` deve recusar conclusão com questões pendentes. O GET de resultado é somente leitura; conclusão e eventual reset ocorrem por POST, sob trava do estudante.

### 3. Sincronização do Ranking Global (`Leaderboard`) e Pontuações
- **RF-008**: Sempre que submissões ou tentativas forem removidas (em `Level#reset_progress_for`, via `after_commit` de destruição em `QuestionSubmission`), o `Leaderboard` e o `total_score` do estudante devem ser recalculados.
- **RF-009**: `QuestionSubmission#answer` deve gravar a pontuação obtida na coluna `score` (`10`, `20`, `30` ou `0`), e `User#update_leaderboard` deve manter a coluna `users.total_score` sincronizada com `leaderboards.total_score`.

### 4. Validações de Models, Painel Admin e Relatórios CSV
- **RF-010**: O model `Admin` deve validar presença, formato de e-mail (`URI::MailTo::EMAIL_REGEXP`) e unicidade case-insensitive de `email_address`.
- **RF-011**: `Admin::LevelsController#destroy` deve verificar o resultado de `@level.destroy`: exibir `notice` apenas em caso de sucesso e redirecionar com `alert` explicativo caso o nível possua temas vinculados (`dependent: :restrict_with_error`).
- **RF-012**: `Admin::DashboardsController#show` deve contabilizar em `@themes_completed` apenas tentativas efetivamente concluídas (`ThemeAttempt.completed.count`).
- **RF-013**: A exportação CSV em `Admin::ReportsController` deve sanitizar campos textuais que comecem com caracteres de fórmula (`=`, `+`, `-`, `@`, `\t`, `\r`) prefixando aspas simples (`'`), prevenindo *CSV Formula Injection*.

### 5. Interface, Assets, I18n e Higiene do Código
- **RF-014**: Na tela "Sua Jornada" (`dashboard/index.html.erb`), substituir `level.starting_level?` por `level.available_to?(Current.user)`, exibindo badge `"Concluído"` para níveis já aprovados e `"Em progresso"` para o nível aberto atual, além de indicar visualmente os temas já concluídos.
- **RF-015**: O helper `level_image_path` deve aceitar a posição/índice sequencial do nível (1 a 5) ou calcular sua ordem para exibir `ods-1.png` a `ods-5.png` corretamente, mesmo que os IDs primários da tabela `levels` sejam diferentes de `1..5`.
- **RF-016**: O avatar no topo das telas do estudante deve exibir a inicial real do `Current.user.full_name` com link acessível para `profile_path`.
- **RF-017**: Remover os scripts temporários `patch_auth.rb` e `rename_to_admin.rb` da raiz, remover Stimulus controllers mortos (`hello_controller.js`, `accordion_controller.js`), traduzir mensagens em inglês para `pt-BR` via I18n e padronizar botões das subtelas administrativas na paleta Emerald.

## Critérios de Sucesso

1. Um estudante recém-cadastrado que responder $\ge 70\%$ das questões de todos os temas do Nível 1 visualiza o Nível 2 desbloqueado e jogável imediatamente ao retornar para `/jornada`.
2. Tentativas de acesso direto via URL/POST a temas de níveis bloqueados ou `/finish` de temas incompletos são bloqueadas pelo servidor.
3. `bin/rubocop -a`, `bin/brakeman --no-pager`, `bin/bundler-audit`, `bin/rails test` e `bin/rails test:system` passam integralmente com 0 falhas e 0 erros.

## Consolidação de 10/11/2026

Este PRD foi incorporado da branch `arthur-testes` e adaptado à implementação segura de `rafael`. Uma tentativa de repetição em andamento preserva o resultado concluído anterior para acesso aos níveis seguintes. A conclusão da nova tentativa passa a valer quando efetivada; reprovação do nível mantém a regra existente de reset. A seleção retorna no máximo uma tentativa por tema diretamente no PostgreSQL, priorizando a concluída mais recente.

A consolidação também resolve as quatro pendências da segunda revisão: consulta sem carregar todo o histórico, cadastro concorrente com erro de formulário, ranking restaurado após desbloqueio e destinos independentes de login administrativo/estudantil. Não introduz novas finalidades de dados nem alterações nos documentos jurídicos.
