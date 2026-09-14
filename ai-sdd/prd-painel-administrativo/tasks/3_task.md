# Tarefa 3.0: Modelo e CRUD de Temas

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Criar a tabela de Temas e associá-los aos Níveis. Implementar as views para listá-los (Drill-down a partir de um Nível).

## Requisitos Atendidos

- RF-005: CRUD de Temas.
- RF-006: Obrigatório associar a um Nível.
- RF-007: Campos obrigatórios (Nome, Descrição, Ícone).

## Design de Referência
Ver `ai-sdd/prd-painel-administrativo/design.md`. Telas desta task:
- #2 Lista de Temas (Drill-down) — Origem: Paper — Ref: `1A-0`

## Conformidade com Standards

- **Tech Spec**: A exclusão de um Nível com Temas dentro deve falhar.

## Subtarefas

- [x] 3.1 Gerar o modelo `Theme` (name:string, description:text, icon:string, level:references).
- [x] 3.2 Modificar o model `Level` para `has_many :themes, dependent: :restrict_with_error`.
- [x] 3.3 Adicionar validações de presença no `app/models/theme.rb`.
- [x] 3.4 Criar o `Admin::ThemesController` e rotas aninhadas rasas (shallow nesting).
- [x] 3.5 Desenvolver a view `index` baseada no Artboard 2 (mostrando o Breadcrumb do Nível pai).
- [x] 3.6 Desenvolver as views de form para o Tema.

## Critérios de Sucesso

- [x] Nível que contém Temas não pode ser apagado do banco de dados (retorna erro).
- [x] Breadcrumb exibe corretamente o nome do Nível pai ao listar os Temas.
- [x] Todos os testes passando.

## Testes

### Testes Unitários
- [x] Tentar deletar um Nível com Tema -> falha (restrict_with_error).

### Testes E2E (se aplicável)
- [x] (Capybara) Admin navega de um Nível para seus Temas, visualizando a lista correspondente.

## Arquivos Relevantes
- `app/models/theme.rb`
- `app/models/level.rb`
- `app/controllers/admin/themes_controller.rb`
- `app/views/admin/themes/index.html.erb`

## Dependências
- Tarefa 2.0: Modelo e CRUD de Níveis

