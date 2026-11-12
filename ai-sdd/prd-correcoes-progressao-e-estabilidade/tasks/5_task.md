# Tarefa 5.0: Higienização do Repositório, I18n, Padronização Admin e Testes E2E

**Objetivo:** Remover scripts órfãos e controllers Stimulus sem uso, traduzir strings em inglês para `pt-BR`, padronizar botões restantes do Admin na paleta Emerald e eliminar flakiness na suíte `bin/rails test:system`.

**Requisitos cobertos:** RF-017

## Subtarefas

- [x] 5.1 **Limpeza de Arquivos Órfãos:** Remover `patch_auth.rb`, `rename_to_admin.rb`, `app/javascript/controllers/hello_controller.js` e `app/javascript/controllers/accordion_controller.js`.
- [x] 5.2 **I18n & Textos:** Traduzir alertas e notices em inglês em `Admin::SessionsController`, `Admin::PasswordsController` e `admin/sessions/new.html.erb`, e ajustar o fallback `"Qta Rails8"` nos layouts para `t("app.name")`.
- [x] 5.3 **Padronização Visual Admin:** Alinhar botões azuis remanescentes em `admin/themes`, `admin/questions` e partials `_form.html.erb` para a paleta Emerald (`bg-emerald-800`).
- [x] 5.4 **Estabilidade E2E e Auditoria Final:** Ajustar sincronização de navegação em `test/system/admin/admins_test.rb` e executar `bin/rubocop -a`, `bin/brakeman --no-pager`, `bin/bundler-audit`, `bin/rails test` e `bin/rails test:system`.

## Arquivos Relacionados
- `patch_auth.rb` (Remover)
- `rename_to_admin.rb` (Remover)
- `app/javascript/controllers/hello_controller.js` (Remover)
- `app/javascript/controllers/accordion_controller.js` (Remover)
- `app/controllers/admin/sessions_controller.rb`
- `app/controllers/admin/passwords_controller.rb`
- `app/views/admin/sessions/new.html.erb`
- `app/views/layouts/application.html.erb`
- `app/views/layouts/admin.html.erb`
- `test/system/admin/admins_test.rb`
