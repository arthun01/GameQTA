# Design — inteligencia-analitica-moderacao

> Documento único de design desta feature. Consumido por `cria-techspec` e `executa-task`.

**Status:** Aprovado

**Ferramenta principal:** Descrição textual (Tailwind)

---

## Telas

| # | Tela | RF cobertos | Breakpoint | Origem | Referência |
|---|------|-------------|-----------|--------|-----------|
| 1 | Dashboard Analítico | RF-001, RF-002 | desktop, mobile | Texto | Ver "Descrições" abaixo (#1) |
| 2 | Relatórios (Exportação) | RF-003 a RF-006 | desktop, mobile | Texto | Ver "Descrições" abaixo (#2) |
| 3 | Listagem de Estudantes (Moderação) | RF-007 a RF-009 | desktop | Texto | Ver "Descrições" abaixo (#3) |
| 4 | Gestão de Administradores | RF-010 a RF-012 | desktop | Texto | Ver "Descrições" abaixo (#4) |

---

## Descrições (apenas para telas com Origem = Texto)

### #1. Dashboard Analítico
- **Localização:** Tela inicial do painel admin (`/painel`).
- **Estrutura:** Um grid no topo da página (ex: `grid-cols-1 md:grid-cols-3 gap-6`) contendo 3 "Cards" brancos com sombras leves (`shadow-sm rounded-lg bg-white p-6`).
- **Conteúdo dos Cards:**
  - Card 1: Título "Total de Estudantes" (texto cinza) e o valor absoluto bem grande (texto escuro `text-3xl font-bold`). Ícone de usuário opcional à direita.
  - Card 2: Título "Média de Acertos" com o valor percentual (ex: 85%).
  - Card 3: Título "Temas Concluídos" com o número total de submissões de sucesso no banco de dados.

### #2. Relatórios (Exportação)
- **Localização:** Nova aba no menu lateral esquerdo do Admin (ex: "Relatórios").
- **Estrutura:** Página limpa com título "Exportação de Dados" e uma breve descrição explicativa.
- **Conteúdo:** Dois grandes painéis horizontais ou cards:
  - Painel 1: "Desempenho Individual" - Texto descritivo e botão azul primário "Exportar CSV de Alunos" com ícone de download.
  - Painel 2: "Desempenho por Tópico" - Texto descritivo e botão azul primário "Exportar CSV de Temas".
- **Ação:** O clique nesses botões inicia instantaneamente o download do arquivo.

### #3. Listagem de Estudantes (Moderação)
- **Localização:** Aba "Estudantes" (já deve existir, mas será expandida).
- **Estrutura:** Tabela padrão do painel (como as tabelas de Níveis/Temas). Colunas: Nome, Email, Pontuação, Tempo, Status, Ações.
- **Conteúdo (Moderação):**
  - **Coluna Status:** Exibe uma badge verde (`bg-green-100 text-green-800`) "Ativo" ou vermelha (`bg-red-100 text-red-800`) "Bloqueado".
  - **Coluna Ações:** Botão vermelho "Bloquear" se o usuário estiver ativo, ou um botão cinza/neutro "Desbloquear" se já estiver bloqueado.
- **Ação:** O clique em "Bloquear" abre um alerta nativo de confirmação (Turbo Confirm).

### #4. Gestão de Administradores
- **Localização:** Nova aba no menu "Administradores".
- **Estrutura (Index):** Tabela padrão de listagem mostrando o e-mail dos administradores e a data de criação. Botão "Novo Administrador" no cabeçalho.
- **Estrutura (Formulário):** Layout de formulário igual ao de Temas/Níveis:
  - Título "Cadastrar Administrador".
  - Campo "E-mail" (`email_field`).
  - Campo "Senha" (`password_field`).
  - Campo "Confirmação de Senha" (`password_field`).
  - Botão "Salvar" primário.

---

## Notas para a Tech Spec

- **Padrões reutilizáveis:** O design herda os partials e as lógicas de layout administrativo já implementadas na Fase 1. Não é necessário inventar layouts do zero; as tabelas devem usar a mesma classe `min-w-full divide-y divide-gray-300` usada em `Levels` e `Themes`.
- **Navegação (Sidebar):** Atualizar a navegação do layout admin (`app/views/layouts/admin.html.erb` ou similar) para incluir os links para Dashboard (root do painel), Administradores, Estudantes e Relatórios.

## Notas para Implementação

- Reutilize formulários nativos do Rails para a criação dos botões de exportação CSV (`button_to`).
- A badge de "Bloqueado" e os botões condicionados requerem verificação simples no modelo (`user.blocked?`). Use helpers de view para encapsular a lógica de cor (verde/vermelho).
