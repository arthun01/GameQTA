# Tarefa 2.0: Modelo e CRUD de Níveis

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Criar a base de dados e a interface administrativa para gerenciar os Níveis do jogo, construindo a primeira etapa do fluxo "Drill-down".

## Requisitos Atendidos

- RF-003: CRUD de Níveis
- RF-004: Campos obrigatórios (Nome, Descrição, Ícone)

## Design de Referência
Ver `ai-sdd/prd-painel-administrativo/design.md`. Telas desta task:
- #1 Dashboard de Níveis — Origem: Paper — Ref: `1-0`

## Conformidade com Standards

- **AGENTS.md**: Lógica de validação fica no Model. i18n obrigatório para labels e botões (`config/locales/pt-BR.yml`). Views em ERB usando Tailwind.

## Subtarefas

- [x] 2.1 Gerar o modelo `Level` (name:string, description:text, icon:string).
- [x] 2.2 Adicionar validações de presença no `app/models/level.rb`.
- [x] 2.3 Criar o controlador `Admin::LevelsController` (herdando do controlador base autenticado gerado na Task 1).
- [x] 2.4 Criar o layout `app/views/layouts/admin.html.erb` com a Sidebar proposta no Design.
- [x] 2.5 Desenvolver a view `index` usando cards para exibir os Níveis (baseado no Artboard).
- [x] 2.6 Desenvolver as views `new`, `edit` e os fluxos de `create`, `update`, `destroy`.

## Detalhes de Implementação

- **Referência**: Ver seção "Modelos de Dados" em `techspec.md`.
- **Pontos de atenção**: Extraia a Sidebar para um partial (`app/views/admin/shared/_sidebar.html.erb`) para manter o layout limpo e reaproveitável.

## Critérios de Sucesso

- [ ] Tabela `levels` criada no banco com as restrições (null: false) corretas.
- [ ] Admin consegue criar, editar, listar e apagar Níveis pela interface administrativa.
- [ ] Layout segue visual base da Sidebar + Header + Grid de Cartões definidos no design.
- [ ] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes Unitários
- [x] Validação falha se tentar salvar `Level` sem `name` ou `description`.

### Testes E2E (se aplicável)
- [x] (Capybara) Admin acessa `/admin/levels`, preenche form de novo nível e vê o card recém-criado na lista.

## Arquivos Relevantes

- `app/models/level.rb` — Novo — Regras de negócio e validação
- `app/controllers/admin/levels_controller.rb` — Novo — Controlador REST
- `app/views/layouts/admin.html.erb` — Novo — Layout geral do painel
- `app/views/admin/levels/index.html.erb` — Novo — Tela baseada no Artboard 1

## Dependências

- Tarefa 1.0: Setup do Projeto e Autenticação Administrativa

