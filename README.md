<div align="center">
  <h1>🌿 Game QTA: Jogo de Direito Ambiental</h1>
  <p><i>Projeto de Extensão Universitária - UESC (Universidade Estadual de Santa Cruz)</i></p>
</div>

---

## 📖 Sobre o Projeto

O **Game QTA** é uma plataforma educacional gamificada concebida como um **Projeto de Extensão na UESC**. Seu objetivo primário é democratizar e facilitar o aprendizado de **Direito Ambiental** para o público jovem (alunos do ensino fundamental e médio), transformando pautas densas e leis complexas em uma jornada interativa e envolvente.

O ecossistema é dividido em duas frentes complementares:
1. **🎮 A Jornada do Estudante (Mobile-First):** Um jogo onde o aluno consome pílulas de conhecimento (vídeos via YouTube), responde a desafios de múltipla escolha e absorve artigos de feedback. A progressão é regida por uma taxa de acerto mínima de 70% e coroada por um Ranking Global (gamificação).
2. **⚙️ O Sistema de Gerenciamento (Backoffice):** Um robusto painel de controle (Painel Administrativo) voltado para a equipe de educadores e criadores do projeto. Permite o cadastro completo da "árvore do conhecimento" (Níveis > Temas > Questões) e fornece dados analíticos sobre o desempenho dos alunos.

---

## 🚀 Status do Projeto

> **Status Atual:** MVP Concluído (Fases 1 a 5 Completas). Prontos para Homologação e Produção.

### 📍 O que TEMOS atualmente (Feito)

**Planejamento Estratégico (Metodologia AI-SDD):**
- [x] Visão do Produto (`ai-sdd/system/vision.md`)
- [x] Mapa de Produto (`ai-sdd/system/product_map.md`)
- [x] Roadmap Completo em 5 Fases (`ai-sdd/system/roadmap.md`)
- [x] **Fase 1 (Painel Admin):** PRD, Design, Tech Spec e Tasks (`ai-sdd/prd-painel-administrativo/`)
- [x] **Fase 2 (Onboarding):** PRD, Design no Paper, Tech Spec e Tasks (`ai-sdd/prd-onboarding-estudante/`)
- [x] **Fase 3 (Gameplay):** PRD, Design no Paper, Tech Spec e Tasks (`ai-sdd/prd-gameplay-estudante/`)
- [x] **Fase 4 (Gamificação):** PRD, Design no Paper, Tech Spec e Tasks (`ai-sdd/prd-gamificacao-ranking/`)
- [x] **Fase 5 (Moderação):** PRD, Tech Spec e Tasks (`ai-sdd/prd-inteligencia-analitica-moderacao/`)

**Implementação (Código Base):**
- **Fase 1 — Painel Administrativo (100% Concluído):**
  - [x] **Tarefa 1.0:** Setup do Projeto (Rails 8, Tailwind, PostgreSQL) e Autenticação Administrativa (Modelo `Admin`).
  - [x] **Tarefa 2.0:** Modelo e CRUD de Níveis (Interface protegida, Grid de Cards).
  - [x] **Tarefa 3.0:** Modelo e CRUD de Temas (Navegação Drill-down a partir do Nível, restrições em cascata).
  - [x] **Tarefa 4.0:** Motor e Banco de Dados de Questões (Validação rigorosa de apenas 1 opção correta no BD).
  - [x] **Tarefa 5.0:** Formulário Frontend de Questões (Campos dinâmicos com JS Stimulus e inclusão de embeds de vídeo).
- **Fase 2 — Onboarding e Interface do Estudante (100% Concluído):**
  - [x] **Tarefa 1.0:** Modelo `User`, `UserSession` e Enum de Escolaridade.
  - [x] **Tarefa 2.0:** Layout Mobile-First, Autenticação Isolada e Telas de Cadastro (`/cadastrar`) e Login (`/entrar`).
  - [x] **Tarefa 3.0:** Motor de Progresso Base (Backend de Níveis).
  - [x] **Tarefa 4.0:** Lobby do Jogador (Frontend da Trilha de Níveis e Teaser de Temas Bloqueados).
- **Fase 3 — Gameplay e Motor de Progressão do Estudante (100% Concluído):**
  - [x] **Tarefa 1.0:** Infraestrutura de Dados (`ThemeAttempt`, `QuestionSubmission`, `GameSetting` para tempos por dificuldade).
  - [x] **Tarefa 2.0:** Motor de Inicialização (`Play::ThemesController#start`), Embeds YouTube responsivos e visualização de consumo.
  - [x] **Tarefa 3.0:** Dinâmica de Revelação (Hotwire Turbo Streams) e Cronômetro Stimulus (`gameplay_timer_controller.js`) com contagem regressiva por dificuldade.
  - [x] **Tarefa 4.0:** Submissão Segura, Anti-Cheat (validação no servidor do tempo decorrido) e Modal de Feedback de Erro (`9D-0`).
  - [x] **Tarefa 5.0:** Progressão de Nível e Regra dos 70% (Tela de resultado `9E-0`, reset em transação em caso de reprovação ou avanço em caso de aprovação).

- **Fase 4 — Gamificação e Competição (100% Concluído):**
  - [x] **Tarefa 1.0:** Backend de Ranking (`Leaderboard`, algorítmos de score baseados na dificuldade e tempo total como desempate).
  - [x] **Tarefa 2.0:** Processamento Assíncrono (`UpdateUserJob` com Solid Queue) para manter a performance nas submissões.
  - [x] **Tarefa 3.0:** Frontend e UI do Pódio Global (`/ranking`), integração de posição com navegação no Dashboard (`<details>` accordion cascata).
- **Fase 5 — Inteligência Analítica & Moderação (100% Concluído):**
  - [x] **Tarefa 1.0:** Fundação da Moderação (Model User, bloqueios lógicos em Sessão e remoção do Leaderboard).
  - [x] **Tarefa 2.0:** Dashboard Admin (Estatísticas globais) e interface Turbo Stream para banimento em tempo real na Listagem de Estudantes.
  - [x] **Tarefa 3.0:** Exportação e Relatórios CSV (Streaming seguro de dados de estudantes e consultas O(1) de agregação de performance em temas).
  - [x] **Tarefa 4.0:** CRUD de Equipe Administrativa (Gerenciamento de contas de administrador com proteções de auto-exclusão e trancamento).

### 🚧 Próximos Passos (O que NÃO TEMOS)

- [ ] Todas as fases do escopo MVP inicial foram concluídas com sucesso. O sistema está preparado para deploy de produção e iterações de balanceamento de game design (tuning de pontos e tempos).

---

## 🛠 Stack Tecnológica

O projeto adere estritamente ao ecossistema "The Rails Way", garantindo longevidade e baixa manutenção.
- **Linguagem / Framework:** Ruby 4.0.2 / Rails 8.1
- **Banco de Dados:** PostgreSQL
- **Frontend:** Hotwire (Turbo + Stimulus), Tailwind CSS, Propshaft + Importmap (Zero dependência de Node.js).
- **Trabalhos em Background e WebSockets:** Solid Queue, Solid Cache, Solid Cable.
- **Testes:** Minitest + Fixtures, System Tests com Capybara.

---

## 📚 Documentação e Guias do Projeto

O conhecimento, regras e manuais de operação deste projeto estão centralizados no nosso portal interno de documentação.

Se você acabou de chegar no projeto, por favor leia os guias abaixo:
- 📖 [Portal Principal da Documentação (Índice)](./docs/README.md)
- 🧠 [Regras de Negócio & Escopo](./docs/BUSINESS_RULES.md) (Ranking, aprovação, pontos)
- 👨‍💻 [Guia de Desenvolvimento](./docs/DEVELOPMENT_GUIDE.md) (Arquitetura Rails, testes, padrões)
- 🛡️ [Guia Administrativo](./docs/ADMIN_GUIDE.md) (Como operar o backoffice e a moderação)
- 🎮 [Guia do Estudante](./docs/USER_GUIDE.md) (Como a dinâmica do jogo funciona para o usuário)

💡 **Quer ver o que vem por aí ou tem ideias para a v2.0?**
- 🚀 [Acesse o Backlog Estratégico (Pós-MVP)](./ai-sdd/system/backlog.md)

*(Nota Histórica: O histórico imutável do planejamento das sprints iniciais usando a metodologia AI-SDD repousa preservado na pasta `/ai-sdd/`).*

---

## 💻 Como Preparar o Ambiente e Executar (Para Iniciantes)

Se você nunca trabalhou com Ruby on Rails, siga o passo a passo abaixo para configurar a sua máquina (focado em Linux/Ubuntu, MacOS ou WSL no Windows):

### 1. Instalar as Dependências Básicas e o Banco de Dados (PostgreSQL)

O nosso projeto usa o banco de dados PostgreSQL. Precisamos instalá-lo primeiro.
No terminal, rode:

**Ubuntu/Linux (ou WSL):**
```bash
sudo apt update
sudo apt install curl g++ gcc autoconf automake bison libc6-dev libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool libyaml-dev make pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev
sudo apt install postgresql postgresql-contrib libpq-dev
```

**MacOS:**
```bash
brew install postgresql
brew services start postgresql
```

### 2. Instalar o Gerenciador de Versões do Ruby (rbenv)

Nunca instale o Ruby direto no sistema. Usaremos o `rbenv` para controlar a versão certinha do projeto.

```bash
# 1. Instalar o rbenv e o ruby-build
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# 2. Adicionar ao seu terminal (se usar bash)
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
```
*(Se você usar `zsh`, substitua `.bashrc` por `.zshrc` nos comandos acima).*

### 3. Instalar o Ruby e o Rails

Agora vamos instalar a linguagem de programação (Ruby) e a base do sistema.

```bash
# Instalar a versão do Ruby que o projeto pede
rbenv install 3.3.0 # ou a versão listada no arquivo .ruby-version do projeto
rbenv global 3.3.0

# Instalar o Bundler (gerenciador de pacotes do Ruby) e o Rails
gem install bundler
gem install rails
```

### 4. Setup do Projeto Game QTA

Com a linguagem instalada, vamos baixar e rodar o nosso jogo:

```bash
# 1. Entre na pasta do projeto
cd pasta-do-projeto-game-qta

# 2. Instale todas as dependências e crie o banco de dados magicamente
bin/setup

# 3. Rode o servidor de desenvolvimento (Deixe essa aba do terminal aberta!)
bin/dev
```

Pronto! Agora é só abrir o seu navegador e acessar: **http://localhost:3000**

### 🧪 Rodando os Testes (Para Desenvolvedores)

Se você for programar, antes de enviar seu código, garanta que nada quebrou:
```bash
bin/rubocop -a        # Arruma a formatação do código
bin/rails test        # Roda os testes de unidade
bin/rails test:system # Roda os testes simulando cliques no navegador
```
