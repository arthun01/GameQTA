# Tarefa 2.0: Sincronização do Ranking (`Leaderboard`) em Resets e Pontuações

**Objetivo:** Garantir que o `Leaderboard`, `users.total_score` e `question_submissions.score` permaneçam coerentes ao responder questões e reprovar/resetar níveis, respeitando o processamento dos jobs.

**Requisitos cobertos:** RF-008, RF-009

## Subtarefas

- [x] 2.1 **Pontuação em `QuestionSubmission`:** Em `answer(option_id:)`, calcular e persistir `score` (`10`, `20`, `30` ou `0`) e incluir `:destroy` no callback `after_commit :update_leaderboard, on: %i[ create update destroy ]`.
- [x] 2.2 **Sincronização em `User#update_leaderboard`:** Atualizar também `total_score` na tabela `users` além do `Leaderboard.upsert`.
- [x] 2.3 **Recálculo no Reset de Nível:** Garantir em `Level#reset_progress_for(user)` o agendamento após commit de recálculo, preservando as proteções para contas bloqueadas/excluídas; testes executam os jobs para verificar o resultado.
- [x] 2.4 **Testes de Unidade:** Adicionar testes em `test/models/leaderboard_test.rb` e `test/models/user_test.rb` verificando que o reset de nível recalcula e zera os pontos daquelas tentativas no ranking.

## Arquivos Relacionados
- `app/models/question_submission.rb`
- `app/models/user.rb`
- `app/models/level.rb`
- `test/models/leaderboard_test.rb`
- `test/models/user_test.rb`
