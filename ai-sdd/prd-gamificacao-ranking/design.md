# Design — gamificacao-ranking

> Documento único de design desta feature. Consumido por `cria-techspec` e `executa-task`.

**Status:** Aprovado
**Ferramenta principal:** Paper Desktop

---

## Telas

| # | Tela | RF cobertos | Breakpoint | Origem | Referência |
|---|------|-------------|-----------|--------|-----------|
| 1 | Tela de Ranking | RF-006, RF-007, RF-008, RF-009 | mobile | Paper | `BB-0` — `gamificacao-ranking / Tela de Ranking / mobile` |

---

## Notas para a Tech Spec

- A tela de ranking lista os top 10 alunos usando cards simples.
- A posição do aluno atual deve ser fixada na base da tela para fácil visibilidade, garantindo contraste com o restante da rolagem.
- Partials recomendados para os itens da lista do ranking (reutilizáveis).
- Uso intensivo de Tailwind CSS para definir os badges do Top 3 (ouro, prata, bronze).

## Notas para Implementação

- Reutilizar a estrutura de container padrão (`max-w-md mx-auto` para o formato mobile-first).
- Não há necessidade primária de interatividade JS complexa (Stimulus), apenas renderização passiva dos dados recebidos pelo Controller.
