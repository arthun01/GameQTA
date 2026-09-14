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

> **Status Atual:** Fase 1 em Desenvolvimento (Construção do Painel Administrativo/MVP).

### 📍 O que TEMOS atualmente (Feito)

**Planejamento Estratégico (Metodologia AI-SDD):**
- [x] Visão do Produto (`ai-sdd/system/vision.md`)
- [x] Mapa de Produto (`ai-sdd/system/product_map.md`)
- [x] Roadmap Completo em 5 Fases (`ai-sdd/system/roadmap.md`)
- [x] PRD do Painel Administrativo (`ai-sdd/prd-painel-administrativo/prd.md`)
- [x] Design e Telas do Painel Administrativo (`ai-sdd/prd-painel-administrativo/design.md`)
- [x] Especificação Técnica e Quebra de Tarefas do Painel Administrativo

**Implementação (Código Base):**
- [x] **Tarefa 1.0:** Setup do Projeto (Rails 8, Tailwind, PostgreSQL) e Autenticação Administrativa (Modelo `Admin`).
- [x] **Tarefa 2.0:** Modelo e CRUD de Níveis (Interface protegida, Grid de Cards).
- [x] **Tarefa 3.0:** Modelo e CRUD de Temas (Navegação Drill-down a partir do Nível, restrições em cascata).
- [x] **Tarefa 4.0:** Motor e Banco de Dados de Questões (Validação rigorosa de apenas 1 opção correta no BD).
- [x] **Tarefa 5.0:** Formulário Frontend de Questões (Campos dinâmicos com JS Stimulus e inclusão de embeds de vídeo).

### 🚧 O que NÃO TEMOS (O que precisa ser feito)

**Nas Fases Futuras do Roadmap (Fases 2 a 5):**
- [ ] **Fase 2:** Onboarding e Interface do Estudante (Cadastro com nome, idade, escola, cidade e login do jogador).
- [ ] **Fase 3:** Gameplay e Motor de Progressão (Telas de vídeo, cronômetro de resolução, validação de 70% de acerto).
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
- **Painel Administrativo:** [PRD](ai-sdd/prd-painel-administrativo/prd.md) | [Design](ai-sdd/prd-painel-administrativo/design.md) | [Tech Spec](ai-sdd/prd-painel-administrativo/techspec.md) | [Tasks](ai-sdd/prd-painel-administrativo/tasks.md)

---

## 💻 Como Executar Localmente

**Pré-requisitos:** Docker (para rodar o devcontainer), Ruby e PostgreSQL.

1. **Clonar e Preparar o Banco de Dados:**
   ```bash
   bin/setup
   ```

2. **Rodar o Servidor de Desenvolvimento:**
   *(Isso subirá o servidor Rails e compilará o Tailwind em watch mode)*
   ```bash
   bin/dev
   ```

3. **Executar a Suíte de Testes e Linting:**
   ```bash
   bin/rubocop -a  # Linting e formatação
   bin/rails test  # Testes Unitários e de Integração
   bin/rails test:system # Testes End-to-End
   ```

Acesso via navegador: `http://localhost:3000/admin`
