# EcoGestão: Plataforma Gamificada de Direito Ambiental

> **Status do Projeto:** Fase 1 em Desenvolvimento (MVP).

O Direito Ambiental frequentemente é percebido como um tema denso e difícil pelo público jovem. Este projeto é uma plataforma educacional gamificada que transforma o aprendizado em uma jornada interativa, acessível e envolvente (Mobile-first para os alunos, Painel robusto para administradores).

## 🛠 Stack Tecnológica
- **Linguagem/Framework:** Ruby 4.0.2 / Rails 8.1
- **Banco de Dados:** PostgreSQL
- **Frontend:** Hotwire (Turbo + Stimulus), Tailwind CSS, Importmap (Sem Node.js)
- **Testes:** Minitest + Fixtures
- **Background/Cache/Websocket:** Solid Queue, Solid Cache, Solid Cable

## 📍 O que TEMOS atualmente (Feito)

**Planejamento Estratégico (AI-SDD):**
- [x] Visão do Produto (`ai-sdd/system/vision.md`)
- [x] Mapa de Produto (`ai-sdd/system/product_map.md`)
- [x] Roadmap Completo em 5 Fases (`ai-sdd/system/roadmap.md`)
- [x] PRD do Painel Administrativo (`ai-sdd/prd-painel-administrativo/prd.md`)
- [x] Design e Telas do Painel Administrativo (`ai-sdd/prd-painel-administrativo/design.md`)
- [x] Tech Spec e Quebra de Tarefas do Painel Administrativo

**Implementação (Código):**
- [x] Tarefa 1.0: Setup do Projeto (Rails 8, Tailwind, BD).
- [x] Tarefa 1.0: Autenticação Administrativa nativa (Modelo `Admin`) e proteção de rotas `/admin/`.
- [x] Tarefa 2.0: Modelo e CRUD de Níveis.

## 🚧 O que NÃO TEMOS (O que precisa ser feito)

### Na Fase Atual (Fase 1: Painel Administrativo)
Estas tarefas já estão documentadas e prontas para execução na pasta `ai-sdd/prd-painel-administrativo/tasks/`:
- [ ] **Tarefa 3.0:** Modelo e CRUD de Temas (Drill-down a partir do Nível).
- [ ] **Tarefa 4.0:** Motor e Banco de Dados de Questões (Validação rigorosa de apenas 1 opção correta).
- [ ] **Tarefa 5.0:** Formulário Frontend de Questões (Campos dinâmicos com JS Stimulus e inclusão de links do YouTube).

### Nas Fases Futuras (Fases 2 a 5)
Ainda requerem geração de PRD, Design, Tech Spec e Implementação:
- [ ] **Fase 2:** Onboarding e Interface do Estudante (Cadastro com nome, idade, cidade e login do jogador).
- [ ] **Fase 3:** Gameplay e Progressão (Telas de vídeo do youtube, cronômetro de resolução, bloqueio de 70% de acerto).
- [ ] **Fase 4:** Gamificação e Competição (Cálculo de acertos vs tempo e listagem de Ranking Global).
- [ ] **Fase 5:** Inteligência Analítica e Moderação (Gráficos de dados demográficos, exportações de dados e moderação de alunos).

---
*Este arquivo é atualizado a cada fechamento de ciclo de desenvolvimento para refletir o estado real da aplicação.*
