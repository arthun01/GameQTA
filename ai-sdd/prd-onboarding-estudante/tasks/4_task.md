# Tarefa 4.0: O Lobby do Jogador (Frontend)

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Desenvolver a tela final desta fase, apresentando os cartões dos níveis com base em seus status de bloqueio, interatividade com abas (Bottom Sheet) e cores de aprovação.

## Design de Referência
Ver `ai-sdd/prd-onboarding-estudante/design.md`. Telas desta task:
- #3 Dashboard de Níveis — Origem: Paper — Ref: `5G-0`
- #4 Modal Nível Bloqueado — Origem: Paper — Ref: `5H-0`

## Requisitos Atendidos

- RF-005: Dashboard listando Níveis.
- RF-008: Indicativos visuais de bloqueio.
- RF-009: Modo leitura para Temas.

## Conformidade com Standards

- **AGENTS.md**: Lógica do Teaser de Temas ocultos (Bottom Sheet) pode ser resolvida 100% com JS Stimulus ou classes dinâmicas.

## Subtarefas

- [x] 4.1 Converter o Artboard 3 (`5G-0`) para `.html.erb` no `dashboard/index.html.erb`.
- [x] 4.2 Configurar o laço de repetição `@levels.each` na view.
- [x] 4.3 Aplicar a lógica condicional: `if level.starting_level?` renderiza o layout verde com "Jogar". Senão (`else`), renderiza o card cinza com cadeado.
- [x] 4.4 Inserir o HTML do Artboard 4 (`5H-0`) oculto por padrão (Modal/Bottom Sheet).
- [x] 4.5 Escrever um pequeno controller Stimulus (ex: `modal_controller.js`) ou usar Data Attributes (`<details>`) nativos para que, ao clicar no Nível Bloqueado, o Modal exiba a iteração (`level.themes.each`) daqueles temas.

## Detalhes de Implementação

- **Referência**: Ver "Implementação de UI/UX" na Tech Spec.
- **Pontos de atenção**: Todos os temas listados no Bottom Sheet não podem conter links executáveis (Modo somente leitura para provocar o aluno).

## Critérios de Sucesso

- [x] A tela exibe N níveis idênticos ao cadastrado pelo Admin na Fase 1.
- [x] O visual condiz estritamente com os design system definidos no Paper (cores, padding, ícones).
- [x] Um Nível bloqueado não redireciona para lugar nenhum, apenas levanta a aba para mostrar os temas.
- [x] Todos os testes E2E passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes E2E (Capybara)
- [x] `DashboardSystemTest`: Realizar login como Aluno válido, visualizar que o Nível 1 tem o botão de Play, e clicar no Nível 2 bloqueado verificando a aparição do modal contendo pelo menos o nome de 1 tema lá dentro.

## Arquivos Relevantes

- `app/views/dashboard/index.html.erb` — Novo
- `app/javascript/controllers/...` — Opcional (se usar Stimulus)

## Dependências

- Tarefa 3.0: Backend de Níveis

