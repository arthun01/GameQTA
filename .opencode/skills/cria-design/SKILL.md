---
name: cria-design
description: >-
  Orquestra a criação ou atualização do protótipo visual (telas/wireframes) de uma feature
  a partir do PRD existente. Gera um único arquivo `ai-sdd/prd-[slug]/design.md` por feature.
  Paper-first: tenta usar o Paper Desktop (via MCP) chamando design-in-paper, que registra
  cada tela com seu Paper artboard ID. Fallback agnóstico: se o Paper não estiver disponível
  ou o usuário preferir outra ferramenta (Figma, Sketch, screenshots, descrição textual),
  registra as telas com referências externas no mesmo design.md. Detecta automaticamente
  criação (sem design.md) vs edição (design.md existe).
  Use quando o usuário pedir "criar o design", "criar protótipo", "wireframe da feature",
  "atualizar design", "/cria-design [feature-slug]". Posição no pipeline: após cria-prd,
  antes de cria-techspec.
  QUANDO NÃO: para criar PRD (cria-prd), para implementar telas em código (executa-task +
  paper-to-rails), para criar techspec (cria-techspec).
license: MIT
---

Você é um designer de produto e facilitador de processo, responsável por garantir que toda
funcionalidade tenha um protótipo visual validado antes de virar Tech Spec.

Esta skill é **agnóstica à ferramenta**: prefere o Paper Desktop (via MCP) por causa do pipeline
integrado com Rails, mas suporta qualquer ferramenta externa (Figma, Sketch, Excalidraw,
screenshots, fotos de papel, descrição textual). O artefato gerado é sempre o mesmo —
`design.md` — apenas o conteúdo de cada tela muda conforme a origem.

## Posição no Pipeline AI-SDD

```
cria-prd          ← define requisitos funcionais (RF-XXX) — O QUE e PORQUÊ
      ↓
cria-design       ← ESTA SKILL — gera/atualiza design.md
      ↓
(usuário revisa e aprova visualmente)
      ↓
cria-techspec     ← lê design.md como referência para definir o COMO
```

A etapa de design é **obrigatória para funcionalidades com UI**. Para features puramente de
backend (jobs, integrações, APIs sem UI), o usuário pode marcar `design.md` como N/A.

## Artefato Gerado

| Arquivo | Sempre o mesmo nome |
|---------|---------------------|
| `ai-sdd/prd-[feature-slug]/design.md` | Lista de telas, cada uma com Paper artboard ID **ou** referência externa **ou** N/A |

As skills downstream (`cria-techspec`, `paper-to-rails`, `executa-task`) leem este arquivo e
adaptam o comportamento conforme a coluna **Origem** de cada linha da tabela de telas:
- Origem = `Paper` → `paper-to-rails` usa o Paper MCP (o ID do artboard está na coluna Referência).
- Origem externa (`Figma`, `Sketch`, `Screenshot`, `Texto`, etc.) → `rails-visual-design` usa
  a coluna Referência (URL, path ou apontador para a seção "Descrições") como guia.

---

## Procedimentos

### Passo 1: Validar Pré-requisitos (Obrigatório)

1. Confirme que o slug da funcionalidade foi fornecido (ex.: `pedidos`, `assinatura-mensal`).
2. Verifique que o PRD existe em `ai-sdd/prd-[feature-slug]/prd.md`. Se ausente, **interrompa**
   e direcione para a skill `cria-prd`.
3. Leia o PRD completamente — extraia:
   - Histórias de usuário e fluxos principais.
   - Requisitos funcionais com impacto visual (RF-XXX).
   - Tipo de usuário e contexto de uso (desktop, mobile, ambos).
   - Fora de escopo.

### Passo 2: Detectar Modo (Criação vs Edição)

1. Verifique se `ai-sdd/prd-[feature-slug]/design.md` existe.
   - **Não existe** → **modo criação**. Prossiga para o Passo 3.
   - **Existe** → **modo edição**. Leia o arquivo e identifique:
     - Status atual (rascunho/aprovado/N/A).
     - Telas já registradas com seus modos (Paper ID ou externo).
2. Em modo edição, pergunte ao usuário o que deseja fazer:
   - "Adicionar novas telas" → mantém as existentes, planeja novas.
   - "Atualizar telas existentes" → identifica quais entradas alterar.
   - "Substituir tudo" → confirma operação destrutiva e refaz.
   - "Trocar de ferramenta" → ex.: telas estavam em Figma, agora migrar para Paper (ou vice-versa).

### Passo 3: Detectar Ferramenta de Design

1. **Tente conectar ao Paper MCP**: chame `get_basic_info`.
   - Se responder com sucesso: Paper está disponível.
   - Se falhar: Paper não está disponível.
2. Pergunte ao usuário a ferramenta a usar nesta rodada (apenas para telas novas ou substituídas):

   **Se Paper disponível:**
   - "Paper Desktop detectado. Quer usar o Paper (Recomendado) ou outra ferramenta (Figma, Sketch, descrição textual)?"

   **Se Paper indisponível:**
   - "Paper Desktop não foi detectado. Você quer:
     - Configurar o Paper agora (veja https://paper.design/docs/mcp) e tentar de novo
     - Continuar com uma ferramenta externa (Figma, Sketch, screenshots, descrição textual)
     - Marcar a feature como sem UI (N/A) — apenas para features de backend"

3. Roteamento:
   - **Paper** → Passo 4 (delegar para `design-in-paper`).
   - **Externa** → Passo 5 (registrar referências externas).
   - **N/A** → Passo 6 (registrar feature sem UI).

### Passo 4: Modo Paper — Delegar para design-in-paper

1. Acione a skill `design-in-paper` passando o slug da feature.
2. A skill `design-in-paper` é responsável por:
   - Verificar pré-requisitos do Paper MCP novamente.
   - Ler o PRD e o design system do projeto.
   - Planejar artboards e obter aprovação.
   - Criar/atualizar artboards no Paper.
   - **Escrever ou atualizar `design.md`** adicionando uma linha na tabela `## Telas`
     para cada artboard, com `Origem = Paper` e a Referência combinando o ID do artboard
     com o nome (ex.: `` `<id>` — `orders / Lista de Pedidos / desktop` ``).
3. Após retorno, prossiga para o Passo 7 (orientação final).

### Passo 5: Modo Externo — Registrar Referências

1. Pergunte qual ferramenta externa será usada (Figma, Sketch, Excalidraw, Screenshot, Texto, etc.)
   apenas para contextualizar o campo "Ferramenta principal" de `design.md`.
2. Para cada tela identificada no PRD, colete os campos da tabela:
   - Nome da tela (ex.: "Lista de Pedidos", "Modal de Confirmação").
   - RFs cobertos.
   - Breakpoints (desktop, mobile, tablet).
   - **Origem** (a ferramenta usada para aquela tela: `Figma`, `Sketch`, `Screenshot`, `Texto`, etc.).
   - **Referência**: URL, path local, ou — para origens longas tipo `Texto` — um apontador
     para uma entrada em "## Descrições" no mesmo arquivo (ex.: `Ver "Descrições" abaixo (#3)`).
3. Apresente o plano de telas ao usuário e **aguarde aprovação**:

   ```
   Telas planejadas para [feature-slug]:

   | # | Tela                  | RF          | Breakpoint        | Origem     | Referência |
   |---|-----------------------|-------------|-------------------|------------|------------|
   | 1 | Lista de Pedidos      | RF-01, RF-02| desktop, mobile   | Figma      | https://figma.com/file/XYZ?node-id=1:2 |
   | 2 | Modal de Confirmação  | RF-04       | desktop           | Screenshot | docs/designs/orders-confirm.png |
   | 3 | Empty State           | RF-01       | desktop           | Texto      | Ver "Descrições" abaixo (#3) |

   Posso salvar em design.md?
   ```

4. Após aprovação, escreva `ai-sdd/prd-[feature-slug]/design.md` seguindo o template em
   `assets/design-template.md`. Para telas com Origem = `Texto`, expanda a descrição na
   seção "## Descrições" do arquivo. Em modo edição, preserve as telas existentes que não
   foram alteradas.

### Passo 6: Modo N/A — Feature sem UI

1. Confirme com o usuário que a feature não tem componente visual.
2. Crie/atualize `ai-sdd/prd-[feature-slug]/design.md` com:

   ```markdown
   # Design — [feature-slug]

   **Status:** N/A — feature sem UI.
   **Ferramenta principal:** N/A

   **Justificativa:** [explicação do usuário sobre por que não há telas]

   ## Telas

   _Nenhuma — feature de backend (jobs/integrações/APIs internas)._
   ```

3. Isso permite que `cria-techspec` e `executa-task` saibam que a decisão foi consciente.

### Passo 7: Orientação Final ao Usuário

Após gerar/atualizar `design.md`, informe:

> Design registrado em `ai-sdd/prd-[feature-slug]/design.md`.
>
> Próximos passos:
> 1. Revise o design (no Paper Desktop, nas URLs externas, ou no texto descritivo).
> 2. Itere visualmente até estar satisfeito — não precisa estar 100% final, mas precisa
>    cobrir todos os RFs com impacto visual.
> 3. Quando aprovado, prossiga com `cria-techspec [feature-slug]`.

---

## Skills Relacionadas

| Skill | Relação |
|-------|---------|
| `design-in-paper` | Implementação canônica do modo Paper. Esta skill delega a ela e ela escreve em `design.md`. |
| `paper-to-rails` | Consome linhas com Origem = Paper em `design.md` para gerar ERB. |
| `mcp-paper` | Documentação canônica das tools do Paper MCP. |
| `cria-prd` | Passo anterior — fornece os requisitos visuais. |
| `cria-techspec` | Passo seguinte — lê `design.md` como referência. |
| `executa-task` | Adapta a implementação tela por tela conforme o modo de cada uma em `design.md`. |

---

## Princípios Fundamentais

- **Um arquivo por feature**: `design.md` é o único índice de design — independente de
  ferramenta. Cada tela declara seu modo (Paper, externo, ou N/A).
- **Paper-first, mas não Paper-only**: a ferramenta padrão é o Paper, mas qualquer ferramenta
  serve via referência externa.
- **Design antes de Tech Spec**: visualizar a UI revela requisitos ocultos e simplifica
  decisões arquiteturais.
- **Iteração visual é barata**: incentive iterar no design antes de implementar.
- **Modo edição é first-class**: features evoluem; o design pode ser atualizado sem cerimônia
  via o mesmo comando.

## Lista de Verificação de Qualidade

- [ ] PRD lido e RFs com impacto visual identificados.
- [ ] Modo detectado (criação vs edição).
- [ ] Ferramenta de design escolhida (Paper, externa ou N/A com justificativa).
- [ ] Plano de telas apresentado e aprovado pelo usuário.
- [ ] `design.md` gerado/atualizado com todas as telas e seus modos.
- [ ] Usuário orientado a iterar visualmente antes de prosseguir para techspec.

## Tratamento de Erros

- Se o PRD não existir: interrompa e direcione para `cria-prd`.
- Se o Paper MCP falhar no meio do fluxo: ofereça fallback externo em vez de abortar.
- Se a pasta da feature contiver arquivos legados (`paper-artboards.md` ou `design-references.md`
  de versões anteriores deste pipeline): proponha consolidá-los em `design.md` no formato atual
  antes de prosseguir.
