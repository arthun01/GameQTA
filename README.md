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

> **Status Atual:** Fase 3 Concluída (Fase 4: Gamificação e Ranking em Planejamento).

### 📍 O que TEMOS atualmente (Feito)

**Planejamento Estratégico (Metodologia AI-SDD):**
- [x] Visão do Produto (`ai-sdd/system/vision.md`)
- [x] Mapa de Produto (`ai-sdd/system/product_map.md`)
- [x] Roadmap Completo em 5 Fases (`ai-sdd/system/roadmap.md`)
- [x] **Fase 1 (Painel Admin):** PRD, Design, Tech Spec e Tasks (`ai-sdd/prd-painel-administrativo/`)
- [x] **Fase 2 (Onboarding):** PRD, Design no Paper, Tech Spec e Tasks (`ai-sdd/prd-onboarding-estudante/`)
- [x] **Fase 3 (Gameplay):** PRD, Design no Paper, Tech Spec e Tasks (`ai-sdd/prd-gameplay-estudante/`)

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

### 🚧 O que NÃO TEMOS (O que precisa ser feito)

- [ ] **Fase 4:** Gamificação e Competição (Cálculo de Ranking Global unindo acertos e tempo de resolução).
- [ ] **Fase 5:** Inteligência Analítica e Moderação (Dashboards demográficos, exportações e controle da comunidade).

---

## 🛠 Stack Tecnológica

O projeto adere estritamente ao ecossistema "The Rails Way", garantindo longevidade e baixa manutenção.
- **Linguagem / Framework:** Ruby 4.0.2 / Rails 8.1
- **Banco de Dados:** PostgreSQL
- **Frontend:** Hotwire (Turbo + Stimulus), Tailwind CSS, Propshaft + Importmap (Zero dependência de Node.js).
- **Trabalhos em Background e WebSockets:** Solid Queue, Solid Cache, Solid Cable.
- **Testes:** Minitest + Fixtures, System Tests com Capybara.

---

## 📚 Documentação e Especificações

O projeto utiliza a metodologia **AI-Specification-Driven Development (AI-SDD)**. Todo o planejamento está documentado na pasta `/ai-sdd/`. Antes de codificar qualquer funcionalidade, seus requisitos, arquitetura e interface são aprovados através dos seguintes documentos:
- [Visão do Produto e Problema](ai-sdd/system/vision.md)
- [Mapeamento de Produto (Fluxos)](ai-sdd/system/product_map.md)
- [Roadmap do Projeto](ai-sdd/system/roadmap.md)
- **Fase 1 (Painel Administrativo):** [PRD](ai-sdd/prd-painel-administrativo/prd.md) | [Design](ai-sdd/prd-painel-administrativo/design.md) | [Tech Spec](ai-sdd/prd-painel-administrativo/techspec.md) | [Tasks](ai-sdd/prd-painel-administrativo/tasks.md)
- **Fase 2 (Onboarding do Estudante):** [PRD](ai-sdd/prd-onboarding-estudante/prd.md) | [Design](ai-sdd/prd-onboarding-estudante/design.md) | [Tech Spec](ai-sdd/prd-onboarding-estudante/techspec.md) | [Tasks](ai-sdd/prd-onboarding-estudante/tasks.md)
- **Fase 3 (Gameplay e Progressão):** [PRD](ai-sdd/prd-gameplay-estudante/prd.md) | [Design](ai-sdd/prd-gameplay-estudante/design.md) | [Tech Spec](ai-sdd/prd-gameplay-estudante/techspec.md) | [Tasks](ai-sdd/prd-gameplay-estudante/tasks.md)

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
