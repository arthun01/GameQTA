# Tarefa 2.0: Dashboard e Interface de Moderação de Alunos

**Objetivo:** Criar os cards de resumo métrico na Home do admin e dotar a listagem de Estudantes dos poderes visuais de bloqueio.
**Requisitos cobertos:** RF-001, RF-002, RF-007

## Design de Referência
Ver `ai-sdd/prd-inteligencia-analitica-moderacao/design.md`. Telas desta task:
- #1 Dashboard Analítico — Origem: Texto
- #3 Listagem de Estudantes (Moderação) — Origem: Texto

## Subtarefas
- [ ] 2.1 **Queries do Dashboard:** Modificar `Admin::DashboardsController` com chamadas eficientes como `User.count` e `QuestionSubmission.where(is_correct: true).count`.
- [ ] 2.2 **View do Dashboard:** Substituir o HTML da tela `/admin/painel` pelo Grid com os 3 cards conforme Design.
- [ ] 2.3 **Controller da Moderação:** Criar os actions `block` e `unblock` (via PATCH) em `Admin::StudentsController` que chamam `user.block!` ou `user.unblock!` e respondem via `turbo_stream`.
- [ ] 2.4 **View de Estudantes:** Alterar `app/views/admin/students/index.html.erb` ou o partial da tabela, adicionando a coluna de Status (Badges).
- [ ] 2.5 **Botão de Moderação:** Renderizar os botões (Vermelho para Bloquear, Cinza para Desbloquear) e linká-los aos novos endpoints (com confirm de Turbo).
- [ ] 2.6 **Testes de Sistema:** Atualizar/criar `test/system/admin/students_test.rb` testando o clique de bloqueio visual.

## Critérios de Sucesso
- Acessar `/admin/painel` exibe imediatamente os 3 dados (Estudantes, Média de Acerto e Temas Concluídos).
- O clique no botão "Bloquear" na linha de um aluno renderiza e altera a badge de status da linha assincronamente sem recarregar a página (Turbo Streams).
- Aluno de fato sofre bloqueio em banco (`blocked_at`).

## Arquivos Relacionados
- `app/controllers/admin/dashboards_controller.rb`
- `app/views/admin/dashboards/show.html.erb`
- `app/controllers/admin/students_controller.rb`
- `app/views/admin/students/index.html.erb` (ou partial associado)
- `config/routes.rb`
- `test/system/admin/students_test.rb` (Novo/Modificado)
