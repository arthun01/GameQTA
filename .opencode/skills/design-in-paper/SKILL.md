---
name: design-in-paper
description: >-
  Cria ou atualiza wireframes e designs de UI no Paper (paper.design) a partir
  de um PRD existente. Gera artboards estruturados e Rails-ready (flex layouts,
  tokens do design system, conteúdo real) para revisão humana antes da techspec.
  REQUER: Paper Desktop app rodando + MCP Paper configurado no editor.
  Use quando o usuário pedir "crie o design no Paper", "wireframe no Paper",
  "gere os artboards", "monte a UI no Paper a partir do PRD".
  QUANDO NÃO: Use sem Paper disponível. Para converter design em código Rails
  (ver paper-to-rails). Para criar o PRD (ver cria-prd).
  PRÉ-REQUISITO NO PIPELINE AI-SDD: após cria-prd, antes de cria-techspec.
license: MIT
compatibility: Paper Desktop app + Paper MCP, Rails 8.1+, Tailwind CSS v4
---

Você é um designer de produto especialista em criar wireframes estruturados para Rails no Paper.
Cria artboards Rails-ready: estruturados com flex layouts, tokens do design system, conteúdo real.

## ⚠️ Pré-requisito Obrigatório

Antes de qualquer ação, verifique se o Paper MCP está disponível:

1. Chame `get_basic_info` para verificar a conexão com o Paper Desktop
2. Se falhar: informe o usuário que o Paper Desktop precisa estar aberto e o MCP configurado
3. Consulte: https://paper.design/docs/mcp para instruções de setup

Se o MCP não estiver disponível, **interrompa** e oriente o usuário — não prossiga.

> **📖 Referência de Tools:** Para documentação completa de todas as tools do Paper MCP
> (parâmetros, retornos, exemplos, workflows), consulte a skill **`mcp-paper`**.

---

## Posição no Pipeline AI-SDD

```
cria-prd          ← define requisitos funcionais (RF-XXX)
      ↓
design-in-paper   ← ESTA SKILL — gera artboards no Paper  [OPCIONAL]
      ↓
(usuário revisa e refina visualmente no Paper)
      ↓
cria-techspec     ← usa artboards aprovados como referência
```

---

## Procedimentos

### Passo 1: Ler PRD (Obrigatório)

1. Confirme o slug da feature: `ai-sdd/prd-[feature-slug]/prd.md`
2. Leia o PRD completamente — extraia:
   - Histórias de usuário e fluxos principais
   - Requisitos funcionais com impacto visual (RF-XXX)
   - Tipo de usuário e contexto de uso
   - Fora de escopo

### Passo 1.1: Detectar Modo (Criação vs Edição)

1. Verifique se `ai-sdd/prd-[feature-slug]/design.md` já existe.
   - **Não existe** → modo criação. Prossiga normalmente para o Passo 2.
   - **Existe** → modo edição. Leia a tabela `## Telas` para conhecer as linhas atuais (Origem
     `Paper` e/ou externas).
2. Em modo edição, pergunte ao usuário o que deseja fazer:
   - **Adicionar telas** → planejar novos artboards complementares aos existentes.
   - **Atualizar telas existentes** → identificar quais linhas com Origem = Paper serão
     modificadas; use `get_screenshot` para visualizar o estado atual antes de editar.
   - **Migrar tela externa para Paper** → para uma linha que hoje tem Origem externa, criar
     um artboard novo e atualizar a linha para Origem = Paper com a nova Referência.
   - **Recriar do zero** → confirme com o usuário (operação destrutiva); arquive ou ignore
     os artboards antigos no Paper antes de criar novos.
3. Em modo edição, ao alterar um artboard existente:
   - Use `start_working_on_nodes` no artboard alvo
   - Modifique via `write_html`, `update_node`, ou ferramentas pontuais do Paper MCP
   - Capture `get_screenshot` para confirmar o resultado
   - Atualize a entrada correspondente em `design.md` (preserve IDs, atualize RFs cobertos se mudou)

### Passo 2: Ler Design System (se existir)

1. Verifique se existe `app/assets/stylesheets/application.css` com `@theme`
2. Extraia tokens: cores primárias, tipografia, raios, sombras
3. Se não existir, use tokens genéricos da skill `tailwind-design-system`

### Passo 3: Planejar Artboards

Antes de criar qualquer artboard, apresente ao usuário:

```
Artboards planejados para [feature-slug]:

1. [Nome da Tela] (1440x900 — desktop)
   RF atendidos: RF-01, RF-02
   Conteúdo: [descrever elementos principais]

2. [Nome da Tela] (390x844 — mobile)
   RF atendidos: RF-01
   Conteúdo: [descrever variação mobile]

...

Posso prosseguir com a criação?
```

**Aguarde aprovação antes de criar qualquer artboard.**

### Passo 4: Criar Artboards no Paper

Para cada artboard aprovado:

1. **Encontrar posição** — chame `find_placement` para não sobrepor artboards existentes
2. **Criar artboard** — chame `create_artboard` com nome descritivo:
   - Nomenclatura: `[feature-slug] / [Nome da Tela] / [breakpoint]`
   - Exemplos: `orders / Lista de Pedidos / desktop`, `orders / Modal de Detalhes / mobile`
3. **Escrever HTML** — chame `write_html` com o HTML estruturado
4. **Marcar como em progresso** — chame `start_working_on_nodes` durante criação
5. **Verificar resultado** — chame `get_screenshot` para confirmar o visual
6. **Finalizar** — chame `finish_working_on_nodes`

### Passo 5: HTML para Paper — Regras Fundamentais

O HTML escrito no Paper deve ser **otimizado para conversão Rails**:

```html
<!-- ✅ CORRETO: flex layouts, tokens CSS, sem classes mágicas -->
<div style="display: flex; flex-direction: column; gap: 24px; padding: 32px; background: var(--color-surface);">

  <!-- Page Header -->
  <div style="display: flex; justify-content: space-between; align-items: flex-start;">
    <div style="display: flex; flex-direction: column; gap: 4px;">
      <h1 style="font-size: 24px; font-weight: 600; color: var(--color-text-primary);">
        Lista de Pedidos
      </h1>
      <p style="font-size: 14px; color: var(--color-text-muted);">
        Gerencie todos os pedidos da plataforma
      </p>
    </div>
    <button style="background: var(--color-primary); color: white; padding: 10px 20px;
                   border-radius: 10px; font-size: 14px; font-weight: 500;">
      Novo Pedido
    </button>
  </div>

  <!-- Tabela -->
  <div style="background: white; border-radius: 16px; border: 1px solid var(--color-border);
              box-shadow: var(--shadow-card); overflow: hidden;">
    <!-- ... -->
  </div>
</div>
```

**Regras:**
- Use **flex layouts** — não use grid CSS complexo (dificulta conversão)
- Use **CSS Variables** do design system (`var(--color-primary)`, etc.)
- Use **conteúdo real** — não Lorem Ipsum (extraia do PRD ou invente dados realistas)
- **Nomeie as layers** com `rename_nodes` usando nomes semânticos Rails:
  - `page-header`, `card-list`, `empty-state`, `modal-overlay`, etc.
- Estruture como se fosse ERB: cada seção lógica é um partial potencial

### Passo 6: Padrões de Componentes por Tipo de Tela

#### Index / Lista

```html
<div style="display: flex; flex-direction: column; gap: 24px; padding: 32px;">
  <!-- Page header com actions -->
  <!-- Filtros e busca (se RF exige) -->
  <!-- Tabela ou lista de cards -->
  <!-- Paginação -->
  <!-- Empty state (estado alternativo) -->
</div>
```

#### Show / Detalhes

```html
<div style="display: flex; flex-direction: column; gap: 24px; padding: 32px; max-width: 896px;">
  <!-- Breadcrumb -->
  <!-- Header com status e ações -->
  <!-- Cards de informação agrupados por seção -->
  <!-- Seções relacionadas (comments, timeline, etc.) -->
</div>
```

#### Form / New / Edit

```html
<div style="display: flex; justify-content: center; padding: 32px;">
  <div style="width: 100%; max-width: 640px; display: flex; flex-direction: column; gap: 24px;">
    <!-- Header do formulário -->
    <!-- Seções do formulário agrupadas por contexto -->
    <!-- Ações (submit + cancelar) -->
  </div>
</div>
```

#### Modal

```html
<!-- Overlay -->
<div style="position: fixed; inset: 0; background: rgba(0,0,0,0.4);
            display: flex; align-items: center; justify-content: center; padding: 16px;">
  <!-- Painel do modal -->
  <div style="background: white; border-radius: 24px; padding: 24px;
              width: 100%; max-width: 480px; box-shadow: var(--shadow-modal);">
    <!-- Header + close -->
    <!-- Corpo -->
    <!-- Ações -->
  </div>
</div>
```

### Passo 7: Registrar Artboards em design.md

Após criar/atualizar os artboards, escreva ou atualize `ai-sdd/prd-[feature-slug]/design.md`
seguindo o template em `.opencode/skills/cria-design/assets/design-template.md`.

Adicione uma linha na tabela `## Telas` para cada artboard com **Origem = Paper**. A coluna
**Referência** combina o ID retornado pelo MCP com o nome do artboard:

```markdown
## Telas

| # | Tela | RF cobertos | Breakpoint | Origem | Referência |
|---|------|-------------|-----------|--------|-----------|
| 1 | Lista de Pedidos | RF-01, RF-02 | desktop | Paper | `<artboard-id>` — `orders / Lista de Pedidos / desktop` |
| 2 | Modal de Confirmação | RF-04 | desktop | Paper | `<artboard-id>` — `orders / Modal de Confirmação / desktop` |
```

**Em modo edição:**
- Preserve linhas existentes que não foram alteradas (incluindo telas com Origem externa
  que permaneceram em outra ferramenta).
- Atualize apenas as linhas correspondentes aos artboards modificados.
- Mantenha o campo "Ferramenta principal" do cabeçalho coerente (se a feature mistura origens,
  use "Paper Desktop + [outra]").

---

## Skills Relacionadas

| Skill | Relação |
|-------|---------|
| **`mcp-paper`** | Referência canônica de todas as tools do Paper MCP — parâmetros, retornos, exemplos e workflows compostos. Consulte para detalhes de qualquer tool. |
| `paper-to-rails` | Converte os artboards criados por esta skill em código Rails (ERB + Tailwind + i18n). |
| `tailwind-design-system` | Fornece tokens CSS usados no HTML escrito via `write_html`. |
| `cria-techspec` | Próximo passo no pipeline — usa os artboards aprovados como referência. |
| `cria-prd` | Passo anterior no pipeline — fornece os requisitos funcionais usados aqui. |

---

## Checklist

- [ ] Paper MCP verificado e conectado
- [ ] PRD lido completamente
- [ ] Modo detectado: criação vs edição (verificou `design.md` existente)
- [ ] Design system do projeto consultado
- [ ] Lista de artboards aprovada pelo usuário (novos e/ou atualizações)
- [ ] Artboards criados/atualizados com layouts flex
- [ ] Conteúdo real (não Lorem Ipsum)
- [ ] Layers nomeadas semanticamente
- [ ] Screenshots verificados com `get_screenshot`
- [ ] `design.md` gerado/atualizado com linhas Origem = Paper na tabela e RFs correspondentes
- [ ] Em edição: entradas externas pré-existentes foram preservadas

---

## Orientações para o Usuário após Criação

Após criar os artboards, informe:

> Os artboards foram criados no Paper. Antes de prosseguir para a **techspec**:
> 1. Revise os artboards visualmente no Paper Desktop
> 2. Ajuste espaçamento, cores e hierarquia visualmente conforme necessário
> 3. Quando aprovados, prossiga com `cria-techspec [feature-slug]`
>
> Os artboards estão documentados em `ai-sdd/prd-[feature-slug]/design.md`
