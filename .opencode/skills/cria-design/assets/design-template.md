# Design — [feature-slug]

> Documento único de design desta feature. Consumido por `cria-techspec` e `executa-task`.
> Cada tela tem uma linha na tabela abaixo. A coluna **Origem** define o modo:
> `Paper` (consumido pela `paper-to-rails` via MCP) ou uma ferramenta externa
> (`Figma`, `Sketch`, `Screenshot`, `Texto`, etc., consumido pela `rails-visual-design`).
> É permitido misturar origens diferentes entre telas da mesma feature.

**Status:** [Em rascunho | Aprovado | N/A — feature sem UI]

**Ferramenta principal:** [Paper Desktop | Figma | Sketch | Excalidraw | Screenshots | Descrição textual | N/A]

---

## Telas

| # | Tela | RF cobertos | Breakpoint | Origem | Referência |
|---|------|-------------|-----------|--------|-----------|
| 1 | Lista de Pedidos | RF-01, RF-02 | desktop, mobile | Paper | `<artboard-id>` — `orders / Lista de Pedidos / desktop` |
| 2 | Modal de Confirmação | RF-04 | desktop | Figma | https://figma.com/file/XYZ?node-id=1:2 |
| 3 | Empty State | RF-01 | desktop | Screenshot | `docs/designs/orders-empty.png` |
| 4 | Modal de Erro | RF-05 | desktop | Texto | Ver "Descrições" abaixo (#4) |

> **Origem = Paper** → coluna Referência traz o ID do artboard retornado pelo MCP + nome
> do artboard. **Origem externa** → coluna Referência traz URL, path local ou aponta para
> uma descrição na seção "Descrições" se for longa.

---

## Descrições (apenas para telas com Origem = Texto)

### #4. Modal de Erro

[Descreva a estrutura da tela: layout principal, componentes visíveis, hierarquia,
dados exibidos, ações disponíveis. Quanto mais detalhado, melhor a tech spec.]

---

## Notas para a Tech Spec

[Observações sobre o design que devem influenciar a tech spec: padrões reutilizáveis,
componentes que devem virar partials, interações que precisam de Stimulus, estados
alternativos (loading, empty, error) já cobertos no design.]

## Notas para Implementação

[Pistas para o executa-task: quais componentes existentes podem ser reutilizados,
ordem sugerida de implementação por tela.]
