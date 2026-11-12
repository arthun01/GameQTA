# Tarefa 1.0: Motor de Desbloqueio Real de Níveis, Progressão e Proteção Backend

**Objetivo:** Implementar a lógica completa de conclusão de temas e níveis (`Theme#completed_by?`, `Level#completed_for?`, `passed_by?` e `available_to?`), corrigir o denominador de `Level#score_for(user)` para considerar todas as questões do nível e blindar os recursos REST de início e conclusão contra bypass de níveis bloqueados e finalização prematura de temas.

**Requisitos cobertos:** RF-001, RF-002, RF-003, RF-004, RF-005, RF-006, RF-007

## Subtarefas

- [x] 1.1 **Model `Theme`:** Implementar `completed_by?(user)` validando existência de tentativa `completed` com todas as questões do tema respondidas.
- [x] 1.2 **Model `Level`:** Implementar `completed_for?`, `passed_by?` e `available_to?`, com limiar exato de 70%.
- [x] 1.3 **Cálculo de Nota (`Level#score_for`):** Dividir o número de acertos nas tentativas mais recentes de cada tema pelo total de questões do nível (`Question.where(theme_id: themes.select(:id)).count`).
- [x] 1.4 **Proteção no início:** Impedir início de tema cujo nível não esteja `available_to?(Current.user)`, redirecionando para `jornada_path` com alerta.
- [x] 1.5 **Conclusão por POST:** `ThemeAttempt#complete` recusa questões pendentes e avalia o nível quando todos os temas estiverem concluídos. GET apenas exibe resultado.
- [x] 1.6 **Ordenação de Fixtures e Testes:** Ajustar `test/fixtures/levels.yml` para garantir que `levels(:one)` anteceda `levels(:two)` por ID e adicionar testes unitários e de integração cobrindo o desbloqueio e os bloqueios de segurança.

## Arquivos Relacionados
- `app/models/theme.rb`
- `app/models/level.rb`
- `app/controllers/play/theme_attempts_controller.rb` e `theme_completions_controller.rb`
- `test/fixtures/levels.yml`
- `test/models/level_test.rb`
- `test/controllers/play/themes_controller_test.rb`
