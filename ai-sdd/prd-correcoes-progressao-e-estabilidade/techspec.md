# Especificação técnica — consolidação de progressão, segurança e interface

Atualizada em 10/11/2026. Integra o PRD de `arthur-testes` à governança e às proteções de `rafael`. As APIs abaixo substituem as propostas anteriores de `start`/`finish` mutantes.

## Progressão e repetição

- `ThemeAttempt.latest_for(user)` seleciona no PostgreSQL uma tentativa por tema com `DISTINCT ON (theme_id)`, ordenando por status concluído, criação e ID decrescentes. Preserva a última conclusão durante uma repetição em andamento e evita instanciar todo o histórico.
- `Theme#completed_by?` exige tentativa concluída e todas as questões atuais respondidas. Não considera um tema vazio concluído.
- `Level#completed_for?` verifica todos os temas e questões; `passed_by?` compara `acertos * 100 >= total * 70`. `score_for` arredonda somente para exibição.
- `Level#available_to?` exige aprovação de todos os níveis anteriores por ID. É usado na jornada e nas operações do servidor.
- `User#start_theme` mantém trava do estudante, recusa conteúdo vazio/bloqueado e retoma a tentativa ativa sem perder respostas.
- `ThemeAttempt#complete` mantém a trava, verifica acesso e respostas, conclui a tentativa e avalia o nível independentemente da ordem dos temas. Ao reprovar, `Level#reset_progress_for` remove as tentativas daquele nível.

## Controllers e autenticação

- `Play::ThemeAttemptsController#create`: inicia/retoma via POST; preserva o endereço legado de início.
- `Play::ThemeCompletionsController#create`: conclui via POST e guarda o resultado necessário à repetição idempotente. `show`, acessado pelo GET legado de resultado, não conclui nem apaga progresso.
- `Play::QuestionsController` mantém validações de propriedade da tentativa e disponibilidade do nível.
- `User#save_for_registration` usa savepoint e contexto de registro. Conflito no índice de e-mail vira erro de formulário 422; outras violações únicas são relançadas. O cadastro e seu aceite permanecem atômicos.
- Destinos de retorno usam chaves separadas para estudante e administrador, caminhos relativos e validação de prefixo da área. O destino administrativo não é consumido pelo login estudantil, nem vice-versa.

## Pontuação e ranking

- `QuestionSubmission#answer` grava `score` 10/20/30 conforme dificuldade e acerto; erro/timeout grava zero. Mantém trava e prazo calculado no servidor.
- A criação, atualização ou destruição agenda `Leaderboards::UpdateUserJob` após commit. Na destruição, captura o ID do estudante antes que o pai desapareça.
- `User#update_leaderboard` mantém cálculo a partir das respostas e dificuldades atuais, atualiza `users.total_score` e faz upsert do ranking na mesma transação com trava. O campo `question_submissions.score` registra os pontos atribuídos ao responder; mudanças posteriores de dificuldade podem alterar o total recalculado, conforme o comportamento existente.
- `User#unblock!` recompõe o ranking na própria operação. Jobs pendentes continuam sem recriar classificações de contas bloqueadas/excluídas.
- Resets dependem do processamento dos jobs para refletir a classificação agregada. A operação não adiciona recálculo síncrono duplicado para cada remoção.
- Mantém `DENSE_RANK` e desempate estável de exibição, inclusive posição pessoal fora das dez linhas.

## Administração e exportações

Mantém as proteções de `rafael`: validações e conflito concorrente de e-mail administrativo, proteção contra exclusão do último administrador, feedback real de exclusão de níveis, recuperação de senha válida, revogação de sessões e limites de abuso. Exportações usam `SpreadsheetExport.row`, com tratamento de caracteres invisíveis, normalização e aspas. Métricas distinguem tentativas, respostas fechadas e acertos.

## Interface

- ODS por posição na sequência; a jornada passa `index + 1` ao helper. Em telas sem essa lista, o helper memoriza o mapa de IDs durante a renderização. Arquivo ausente usa o logo.
- Avatar com inicial real e link acessível ao perfil; dentro do jogo o link usa `turbo_frame: "_top"`.
- Níveis aprovados exibem indicador e percentual; temas concluídos exibem indicador próprio. Acordeões seguem recolhíveis.
- Botões primários administrativos Emerald, placeholders em português e nome localizado da aplicação nos metadados.
- Removidos somente scripts e controllers sem referências. Testes de interação usam cliques e seleção reais; JavaScript permanece necessário para simular o timeout já existente e medir a largura da página.

## Validação e limites

Regressões permanentes cobrem cadastros concorrentes com duas conexões, retorno independente das áreas, recomposição após desbloqueio, 500 tentativas históricas, repetição sem bloquear níveis, pontos por dificuldade, limite real abaixo de 70% que arredonda para 70% e jornada no navegador. Executar RuboCop, Brakeman, auditorias de dependências, suíte da aplicação e suíte de navegador sequencialmente para não disputar o banco de testes.

Não há nova migração nesta consolidação. O PR completo mantém a migração anterior de idade opcional, Rails 8.1.4.1 e governança 1.0. Rotinas operacionais de retenção e configuração de e-mail continuam documentadas separadamente.
