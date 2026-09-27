# Tarefa 1.0: Fundação da Moderação (Model User)

**Objetivo:** Permitir que contas de estudantes sejam bloqueadas através da criação do atributo `blocked_at`, invalidando sessões ativas (logout imediato) e removendo-os dos placares globais.
**Requisitos cobertos:** RF-008, RF-009

## Design de Referência
Sem UI/Design associado nesta tarefa (apenas infraestrutura de backend).

## Subtarefas
- [ ] 1.1 **Migração:** Criar e rodar migração `AddBlockedAtToUsers` com a coluna `blocked_at:datetime`.
- [ ] 1.2 **Métodos do Model:** No model `User`, adicionar os métodos lógicos `blocked?`, `block!` e `unblock!`.
- [ ] 1.3 **Transação de Bloqueio:** No método `block!`, garantir a destruição de `user_sessions.destroy_all` e a deleção limpa do `leaderboard`.
- [ ] 1.4 **Barragem de Login:** Atualizar `Users::SessionsController#create` para bloquear explicitamente a geração de sessão se `user.blocked?`, injetando a mensagem "Conta bloqueada".
- [ ] 1.5 **Testes de Unidade:** Adicionar teste em `user_test.rb` garantindo a transação e as destruições das sessões associadas.
- [ ] 1.6 **Testes de Integração:** Atualizar `test/controllers/users/sessions_controller_test.rb` (ou criar) assegurando que login de conta com `blocked_at` não passa.

## Critérios de Sucesso
- Migração no banco executada e mapeada em `schema.rb`.
- Usuário bloqueado perde suas sessões abertas no ato e não consegue mais relogar.
- Usuário bloqueado perde o registro na tabela `leaderboards`.
- A suíte de testes `bin/rails test` deve passar com os novos cenários de bloqueio.

## Arquivos Relacionados
- `db/migrate/*_add_blocked_at_to_users.rb` (Novo)
- `app/models/user.rb`
- `app/controllers/users/sessions_controller.rb`
- `test/models/user_test.rb`
- `test/controllers/users/sessions_controller_test.rb`
