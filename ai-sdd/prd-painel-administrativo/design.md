# Design — painel-administrativo

> Documento único de design desta feature. Consumido por `cria-techspec` e `executa-task`.
> Cada tela tem uma linha na tabela abaixo. A coluna **Origem** define o modo:
> `Paper` (consumido pela `paper-to-rails` via MCP) ou uma ferramenta externa
> (`Figma`, `Sketch`, `Screenshot`, `Texto`, etc., consumido pela `rails-visual-design`).
> É permitido misturar origens diferentes entre telas da mesma feature.

**Status:** Aprovado

**Ferramenta principal:** Paper Desktop

---

## Telas

| # | Tela | RF cobertos | Breakpoint | Origem | Referência |
|---|------|-------------|-----------|--------|-----------|
| 1 | Dashboard de Níveis | RF-01, RF-02, RF-03 | desktop | Paper | `1-0` — `painel-administrativo / Dashboard de Níveis / desktop` |
| 2 | Lista de Temas (Drill-down) | RF-05, RF-06 | desktop | Paper | `1A-0` — `painel-administrativo / Lista de Temas / desktop` |
| 3 | Lista de Questões (Drill-down) | RF-08, RF-09 | desktop | Paper | `2C-0` — `painel-administrativo / Lista de Questões / desktop` |
| 4 | Formulário de Questão | RF-10, RF-11, RF-12 | desktop | Paper | `3I-0` — `painel-administrativo / Formulario de Questão / desktop` |

---

## Notas para a Tech Spec

- **Identidade Visual**: Embora seja uma área administrativa restrita, o design utiliza um layout mais solto (grid de cartões, ícones, breadcrumbs de cores vibrantes) para simular o percurso que o jogador também fará, seguindo a diretriz de UX definida no PRD.
- **Componentização Sugerida**:
  - `CardNivel` e `CardTema` podem virar partials compartilhados, já que a estrutura deles é idêntica (ícone, título, subtítulo, botão de ação e contador de itens internos).
  - O `Breadcrumb` de navegação será um componente crucial que exigirá um helper no Rails para rastrear se estamos visualizando as questões do `Nível > Tema`.
  - No `Formulário de Questão`, a inserção/remoção dinâmica de opções exigirá um Stimulus controller (por exemplo, `nested-form-controller`) ou o uso do Turbo Streams, já que precisamos garantir a marcação de uma única resposta correta (radio button).

## Notas para Implementação

- O menu lateral (Sidebar) deve ser extraído para um layout específico (`app/views/layouts/admin.html.erb`).
- Os campos de "Opções" do formulário precisarão de um cuidado especial no Hotwire/Stimulus para validar a regra RF-12 (apenas 1 marcada como correta) dinamicamente antes de enviar ao servidor.

