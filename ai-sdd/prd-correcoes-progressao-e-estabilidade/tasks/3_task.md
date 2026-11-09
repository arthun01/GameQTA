# Tarefa 3.0: Validações do Model `Admin`, Painel Admin e Proteção CSV Injection

**Objetivo:** Evitar erros 500 no cadastro de administradores, corrigir o feedback de exclusão de níveis com temas, ajustar a contagem de temas concluídos no Dashboard Admin e proteger relatórios CSV contra *Formula Injection*.  
**Requisitos cobertos:** RF-010, RF-011, RF-012, RF-013

## Subtarefas

- [x] 3.1 **Model `Admin`:** Adicionar validações de presença, formato (`URI::MailTo::EMAIL_REGEXP`), tamanho máximo (254) e unicidade em `email_address`.
- [x] 3.2 **`Admin::LevelsController#destroy`:** Verificar se `@level.destroy` teve sucesso antes de exibir `notice`, redirecionando com `alert` caso possua temas associados.
- [x] 3.3 **`Admin::DashboardsController#show`:** Contabilizar apenas `ThemeAttempt.completed.count` em `@themes_completed`.
- [x] 3.4 **`Admin::ReportsController`:** Sanitizar células textuais iniciadas por `=`, `+`, `-`, `@`, `\t` ou `\r` na geração de CSV.
- [x] 3.5 **Testes:** Adicionar testes cobrindo validação de `Admin`, erro ao excluir nível com temas e sanitização de CSV.

## Arquivos Relacionados
- `app/models/admin.rb`
- `app/controllers/admin/levels_controller.rb`
- `app/controllers/admin/dashboards_controller.rb`
- `app/controllers/admin/reports_controller.rb`
- `test/models/admin_test.rb`
- `test/controllers/admin/levels_controller_test.rb`
- `test/controllers/admin/reports_controller_test.rb`
