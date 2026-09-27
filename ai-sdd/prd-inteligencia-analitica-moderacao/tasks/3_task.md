# Tarefa 3.0: Módulo de Relatórios e Exportação CSV

**Objetivo:** Permitir aos analistas de dados o download rápido de planilhas de desempenho (Alunos e Tópicos) de maneira tolerante a altas cargas (sem falha de RAM).
**Requisitos cobertos:** RF-003 a RF-006

## Design de Referência
Ver `ai-sdd/prd-inteligencia-analitica-moderacao/design.md`. Telas desta task:
- #2 Relatórios (Exportação) — Origem: Texto

## Subtarefas
- [x] 3.1 **Rotas e Controller:** Criar `Admin::ReportsController` contendo as rotas `index`, `students` (CSV) e `themes` (CSV). Adicionar item "Relatórios" na Sidebar Admin.
- [x] 3.2 **View de Download:** Construir a tela `index` do Reports com os painéis e botões de baixar o CSV.
- [x] 3.3 **Construção de Cabeçalho (CSV):** Configurar `response_body = Enumerator.new` nos actions de CSV junto com `find_each` do ActiveRecord.
- [x] 3.4 **Relatório Estudantes:** Desenvolver a lógica de parsing que puxa as informações do usuário, seu respectivo `.leaderboard.total_score` e formata a linha.
- [x] 3.5 **Relatório Temas:** Desenvolver a query que agrega e conta, para cada tema, quantos `question_submissions` existem e qual a taxa de verdadeiro/falso (acertos).
- [x] 3.6 **Testes de Integração:** Criar `test/controllers/admin/reports_controller_test.rb` atestando os headers (Content-Disposition: attachment) e chamando as ações sem falhas de timeout.

## Critérios de Sucesso
- Acessar a nova aba "Relatórios" e conseguir clicar e visualizar a caixa de download nativo do browser com a extensão `.csv`.
- CSV de estudantes gerado corretamente (uma linha por aluno e as colunas propostas).
- Arquivos muito grandes sendo quebrados (`Enumerator`) evitando travamentos na aplicação.

## Arquivos Relacionados
- `config/routes.rb`
- `app/controllers/admin/reports_controller.rb` (Novo)
- `app/views/admin/reports/index.html.erb` (Novo)
- `app/views/layouts/admin.html.erb` (Inclusão do link da aba na Sidebar)
- `test/controllers/admin/reports_controller_test.rb` (Novo)
