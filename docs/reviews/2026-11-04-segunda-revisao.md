# Segunda revisão de código - Game QTA

> Atualização de 10/11/2026: os quatro achados abaixo foram corrigidos na consolidação das branches. Este relatório preserva o estado histórico revisado; consulte [decisões e validação da consolidação](2026-11-10-consolidacao-branches.md).

Data: 04/11/2026. Branch: `rafael`. Referência: `10741c9b54fd47c402d89b88f45170fb55cff7a7`, incluindo as alterações locais e os arquivos novos ainda não commitados.

Esta revisão reavaliou as correções anteriores em dois eixos independentes, Standards e Spec, seguidos de reproduções complementares. Foram confirmados quatro achados P2: uma regressão de performance e três defeitos preexistentes que não faziam parte dos 17 itens anteriores. Não foi confirmado novo P1 nesta rodada. A análise não é teste de invasão, teste de carga ou validação da implantação em produção.

## Standards - implementação

### A1 - [P2] Consulta da última tentativa carrega todo o histórico

Referência: [app/models/level.rb:46](../../app/models/level.rb#L46), especialmente a conversão para array na linha 48.

`latest_attempts_for` busca todas as tentativas do estudante nos temas do nível, instancia os registros e só então elimina as antigas com `uniq`. A necessidade é obter apenas a tentativa mais recente por tema. O método passou a integrar cálculo de nota e verificações de acesso usadas na jornada, início e operações de jogo.

Reprodução: um tema com uma tentativa atual e 500 históricas. Uma única chamada pública a `score_for` instanciou **501 objetos ThemeAttempt**, embora precisasse de apenas um. O consumo cresce com o histórico de um estudante ativo. É uma regressão introduzida na refatoração recente em relação à seleção anterior com limite por tema.

Recomendação: selecionar no banco a tentativa mais recente de cada tema e reaproveitar os dados de progresso durante a requisição. O [guia de desenvolvimento](../DEVELOPMENT_GUIDE.md#tratamento-de-dados-performance) orienta evitar consultas repetidas e usar pré-carregamento/agregação.

Também foram medidas consultas SELECT reais na jornada de estudantes com todos os níveis concluídos: 15 para dois níveis, 33 para quatro e 69 para oito. O cache de consultas influencia esse resultado; a medição não demonstra crescimento quadrático de consultas reais. Essa hipótese não foi registrada como achado independente.

### A2 - [P2] Cadastro simultâneo de estudantes pode gerar erro interno

Referência: [app/controllers/users/registrations_controller.rb:11](../../app/controllers/users/registrations_controller.rb#L11).

Duas requisições públicas com o mesmo e-mail podem passar pela validação de unicidade antes de qualquer INSERT terminar. Uma cria a conta e a outra atinge o índice único, lançando `ActiveRecord::RecordNotUnique`, sem tratamento no fluxo de cadastro. A proteção concorrente adicionada à gestão administrativa não abrange esse fluxo.

Reprodução: duas sessões HTTP, duas conexões ao banco e sincronização imediatamente antes do INSERT. Resultado: uma resposta de sucesso por redirecionamento e uma exceção de unicidade, com somente uma conta persistida. O comportamento desejado é recusar a segunda solicitação com erro de formulário, sem erro interno. É um defeito preexistente, não regressão das correções administrativas.

Recomendação: manter o índice único e tratar o conflito dentro de operação com savepoint, retornando erros de validação ao cadastro. Evitar um rescue que deixe a transação abortada.

## Spec - requisitos e fluxos

### B1 - [P2] Estudante desbloqueado permanece fora do ranking

Referências: [app/models/user.rb:119](../../app/models/user.rb#L119), especialmente `unblock!` nas linhas 127-128; [rankings_controller.rb:4](../../app/controllers/rankings_controller.rb#L4).

Bloquear destrói o registro do ranking. Desbloquear apenas limpa `blocked_at`; não recalcula nem agenda recomposição. Respostas e pontos de origem são preservados, mas o estudante não aparece na classificação até uma futura revelação ou resposta disparar outro job.

Reprodução: calcular ranking de estudante com respostas, esvaziar os jobs pendentes, bloquear, desbloquear e abrir `/ranking` com nova sessão. As respostas permanecem, o registro de ranking é `nil` e a posição pessoal não aparece. Isso contraria o objetivo 3 e RF-009 do [PRD de gamificação](../../ai-sdd/prd-gamificacao-ranking/prd.md). Defeito preexistente, fora dos 17 itens anteriores.

Recomendação: recompor o ranking após o desbloqueio efetivo, usando os registros preservados e mantendo os controles contra recriação para conta excluída ou novamente bloqueada.

### B2 - [P2] Destino de retorno mistura login administrativo e estudantil

Referências: [Authentication:37](../../app/controllers/concerns/authentication.rb#L37) e [Users::Authentication:33](../../app/controllers/concerns/users/authentication.rb#L33).

As duas áreas usam `session[:return_to_after_authenticating]` no mesmo cookie de navegação. Uma visita não autenticada a uma rota de estudante pode alterar o destino posteriormente consumido pelo login administrativo, e vice-versa. O login é aceito, mas o participante é enviado à área errada e pode receber outra tela de entrada.

Reprodução: GET `/perfil` sem sessão estudantil, seguido de login administrativo válido. A resposta aponta para `/perfil`; ao seguir o redirecionamento, o navegador acaba em `/entrar`, embora a sessão administrativa tenha sido criada. Isso conflita com a independência das áreas de autenticação e com a retomada do fluxo do perfil correto. Não demonstra acesso indevido aos dados da outra área. Defeito preexistente.

Recomendação: separar os destinos por área de autenticação e validar que cada retorno pertence ao fluxo correspondente, preservando o destino administrativo e estudantil esperados.

## Verificações e limites

| Verificação | Resultado |
|---|---|
| RuboCop, sem autocorreção | 149 arquivos, nenhuma infração |
| Brakeman | Zero alertas e erros |
| Bundler-audit com base atualizada | Nenhuma vulnerabilidade conhecida; base `516ea4757d5eec778c49af8371c23309c4b70f42` |
| Suíte da aplicação | 132 testes, 910 assertions, zero falhas/erros/skips |
| Suíte de navegador | 31 testes, 203 assertions, zero falhas/erros/skips |
| Reproduções complementares | Cinco cenários temporários, 26 assertions, confirmando os comportamentos descritos |

As reproduções afirmam a presença dos problemas, não sua correção. A aprovação das suítes existentes não elimina as lacunas de cobertura encontradas. A implementação não foi alterada nesta rodada; os cenários temporários usam o banco de testes e não enviam mensagens externas.

Evidências locais: `/tmp/gameqta_second_review_test.rb` e `/tmp/gameqta-second-review-*.log`. Os arquivos temporários podem ser limpos pelo ambiente e não substituem a futura inclusão de regressões na suíte permanente. Alterações posteriores ao estado revisado exigem nova verificação.

Total por eixo: Standards, dois achados P2; Spec, dois achados P2. Maior impacto observado em Standards: erro interno no cadastro concorrente. Em Spec: perda da classificação após desbloqueio e redirecionamento para a área de login errada.
