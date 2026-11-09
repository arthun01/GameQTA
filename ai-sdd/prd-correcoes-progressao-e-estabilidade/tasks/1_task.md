# Tarefa 1.0: Motor de Desbloqueio Real de Níveis, Progressão e Proteção Backend

**Objetivo:** Implementar a lógica completa de conclusão de temas e níveis (`completed_by?`, `unlocked_for?`), corrigir o denominador de `Level#score_for(user)` para considerar todas as questões do nível e blindar `Play::ThemesController` contra bypass de níveis bloqueados e finalização prematura de temas.  
**Requisitos cobertos:** RF-001, RF-002, RF-003, RF-004, RF-005, RF-006, RF-007

## Subtarefas

- [x] 1.1 **Model `Theme`:** Implementar `completed_by?(user)` validando existência de tentativa `completed` com todas as questões do tema respondidas.
- [x] 1.2 **Model `Level`:** Implementar `previous_level`, `all_themes_completed_by?(user)`, `completed_by?(user)` e `unlocked_for?(user)`.
- [x] 1.3 **Cálculo de Nota (`Level#score_for`):** Dividir o número de acertos nas tentativas mais recentes de cada tema pelo total de questões do nível (`Question.where(theme_id: themes.select(:id)).count`).
- [x] 1.4 **Proteção em `Play::ThemesController#start`:** Impedir início de tema cujo nível não esteja `unlocked_for?(Current.user)`, redirecionando para `jornada_path` com alerta.
- [x] 1.5 **Proteção e Avaliação em `Play::ThemesController#finish`:** Redirecionar para a questão pendente se `@attempt.next_pending_question.present?`. Avaliar aprovação/reprovação do nível quando `@level.all_themes_completed_by?(Current.user)` ou no último tema concluído.
- [x] 1.6 **Ordenação de Fixtures e Testes:** Ajustar `test/fixtures/levels.yml` para garantir que `levels(:one)` anteceda `levels(:two)` por ID e adicionar testes unitários e de integração cobrindo o desbloqueio e os bloqueios de segurança.

## Arquivos Relacionados
- `app/models/theme.rb`
- `app/models/level.rb`
- `app/controllers/play/themes_controller.rb`
- `test/fixtures/levels.yml`
- `test/models/level_test.rb`
- `test/controllers/play/themes_controller_test.rb`
