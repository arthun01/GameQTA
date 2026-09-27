# Tarefa 4.0: CRUD de Equipe (Gestão de Administradores)

**Objetivo:** Permitir a criação nativa e direta de novos gestores de backoffice definindo e-mail e senha diretamente no painel.
**Requisitos cobertos:** RF-010, RF-011, RF-012

## Design de Referência
Ver `ai-sdd/prd-inteligencia-analitica-moderacao/design.md`. Telas desta task:
- #4 Gestão de Administradores — Origem: Texto

## Subtarefas
- [x] 4.1 **Rotas e Navegação:** Adicionar resources `:admins` sob namespace admin. Incluir link "Equipe/Admins" na Sidebar do admin.
- [x] 4.2 **Controller Administrativo:** Criar `Admin::AdminsController` herdando o concern de segurança. Criar as actions padrão `index`, `new`, `create`, `edit`, `update`, `destroy`.
- [x] 4.3 **View Index (Listagem):** Tabela replicando a estética do Painel exibindo todos os admins cadastrados (sem a senha, obviamente).
- [x] 4.4 **Views New/Edit (Formulários):** Criar `_form.html.erb` permitindo inserção de `email_address`, `password` e `password_confirmation`. Para o Edit, deixar o password opcional.
- [x] 4.5 **Testes de Acesso e Sistema:** Escrever o `admin_management_test.rb` cobrindo o fluxo de criação e deleção (evitando que o último admin seja deletado e perca o acesso geral).

## Critérios de Sucesso
- Conseguir abrir a nova área do Admin, clicar em "Novo", cadastrar um colega, fazer logout, e entrar com sucesso na conta criada.
- A listagem funciona corretamente e herda o visual limpo tailwind que já existia.

## Arquivos Relacionados
- `config/routes.rb`
- `app/controllers/admin/admins_controller.rb` (Novo)
- `app/views/admin/admins/index.html.erb` (Novo)
- `app/views/admin/admins/new.html.erb` (Novo)
- `app/views/admin/admins/edit.html.erb` (Novo)
- `app/views/admin/admins/_form.html.erb` (Novo)
- `test/system/admin/admins_test.rb` (Novo)
