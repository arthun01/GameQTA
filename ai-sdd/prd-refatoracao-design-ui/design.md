# Design Specification - Refatoração de Design, UI/UX & Identidade Visual

## Visão Geral de Design

A refatoração visual conduzida por **Ana Beatriz Guerra Mello** (PR #17) alinha a experiência do usuário com os pilares ecológicos do projeto de extensão da **UESC** (Universidade Estadual de Santa Cruz). A interface equilibra simplicidade, gamificação mobile-first e seriedade pedagógica.

## Design Tokens & Paleta de Cores

A paleta de cores adota como base as classes nativas do Tailwind CSS:

| Token | Classe Tailwind | Hex / Aplicação | Uso Principal |
|-------|-----------------|-----------------|---------------|
| **Primary Brand** | `emerald-600` | `#059669` | Botões principais, links ativos, badges de sucesso |
| **Primary Hover** | `emerald-700` | `#047857` | Hover e active de botões principais |
| **Primary Light** | `emerald-50` / `emerald-100` | `#ecfdf5` | Fundos de cards, badges sutis, destaques |
| **Neutral Surface** | `slate-50` / `white` | `#f8fafc` | Fundos de página e superfícies de cartões |
| **Neutral Text** | `slate-800` / `slate-900` | `#1e293b` | Títulos e corpo de texto principal |
| **Neutral Muted** | `slate-500` / `slate-400` | `#64748b` | Legendas, rodapés e textos secundários |
| **Danger / Lock** | `rose-600` / `amber-600` | `#e11d48` | Erros, bloqueio de níveis, avisos de moderação |

## Tipografia & Hierarquia

- **Fonte:** Sistema padrão sans-serif limpo com renderização antialiased.
- **Títulos de Seção (H1/H2):** `font-bold tracking-tight text-slate-900`.
- **Subtítulos e Badges:** `text-xs font-semibold uppercase tracking-wider`.
- **Textos de Botões:** `font-medium rounded-xl shadow-sm transition duration-150`.

## Assets & Ilustrações

1. **Logo Oficial (`/public/logo_qta.png`):**
   - Utilizada em destaque nas telas de autenticação (Login e Cadastro) e no cabeçalho.
2. **Ilustrações dos Níveis (`/public/ods-1.png` a `ods-5.png`):**
   - Ilustrações quadradas minimalistas associadas às temáticas ambientais e aos ODS (Objetivos de Desenvolvimento Sustentável).
   - Renderizadas em containers com `aspect-square`, `object-cover` e bordas arredondadas suaves (`rounded-2xl`).
3. **Crédito Institucional (`/public/tekohalab.png`):**
   - Inserido nos rodapés integrados na tela de gameplay e login, valorizando a parceria institucional da UESC e do laboratório TekohaLab.

## Componentes Chave

### 1. Navbar Superior da Jornada (`dashboard/index.html.erb`)
- Barra no topo fixando identidade do usuário logado.
- Exibição de pontos acumulados e link rápido para a tela `/ranking`.
- Botão discreto para logout.

### 2. Cards de Nível & Temas Numerados
- Card de Nível com layout visualmente acolhedor:
  - Lado esquerdo/superior: imagem minimalista quadrada (`ods-X.png`).
  - Lado direito/corpo: título do nível, status de desbloqueio e barra de progresso.
- Temas listados com identificador numérico explícito (`1.1`, `1.2`, `2.1` etc.), facilitando a comunicação entre alunos e professores em sala de aula.

### 3. Tela de Pergunta & Modal de Avaliação (`play/questions/show.html.erb`)
- Timer em evidência com animação fluida via Stimulus.
- Opções de resposta em botões de largura total com visualização de clique imediata.
- Rodapé estilizado com os créditos do TekohaLab.

### 4. Backoffice Administrativo (`admin/*`)
- Sidebar moderna com fundo escuro/neutro e destaques em verde esmeralda.
- Tabelas com cabeçalhos consistentes, paginação e espaçamento arejado.
- Ações administrativas padronizadas (botões de edição, visualização e moderação com cores semânticas).
