# Backlog Estratégico & Melhorias (Pós-MVP)

Este documento atua como o repositório central de ideias, melhorias contínuas e *features* futuras para o Game QTA.

O objetivo aqui é **registrar estrategicamente o "O quê", o "Por quê" e os "Critérios Chave"**. Os itens estão organizados em **ordem estrita de prioridade de execução**, permitindo que qualquer desenvolvedor da equipe extraia o item do topo para gerar um PRD completo (usando a metodologia AI-SDD) e iniciar a esteira de desenvolvimento.

---

## 🚨 PRIORIDADE 1 (CRÍTICA / LEGAL): Pacote de Governança Jurídica, LGPD & Acessibilidade

> **Responsabilidade / Motivação:** Como o Game QTA é um projeto de extensão universitária da UESC voltado para o ambiente escolar (alunos dos ensinos fundamental e médio, majoritariamente menores de idade), a conformidade legal e a acessibilidade digital **não são opcionais**, mas sim requisitos regulatórios essenciais para evitar riscos de sanções administrativas (ANPD), processos judiciais e exclusão de estudantes com deficiência.

### 📋 Escopo Detalhado da Feature (Para o Desenvolvedor):

#### 1. Termos de Serviço & Política de Privacidade
- [ ] **Páginas Institucionais Dedicadas:** Criar rotas públicas `/termos` e `/privacidade` (com layout limpo, responsivo e versão para impressão).
- [ ] **Linguagem Acessível (Legal Design / Visual Law):** Textos claros e didáticos, adequados para jovens, pais e professores, explicando exatamente quais dados são coletados e para que finalidade pedagógica.
- [ ] **Direitos do Titular (Art. 18 LGPD):** Instruções explícitas de como o estudante ou seu responsável legal pode solicitar a correção ou a exclusão definitiva dos seus dados.

#### 2. Adequação Estrita à LGPD & Proteção de Crianças e Adolescentes (Art. 14 da LGPD)
- [ ] **Minimização de Dados (Princípio da Necessidade):** Auditar e restringir o formulário de cadastro apenas ao indispensável para a dinâmica do jogo e extensão (Nome, E-mail, Idade, Escolaridade e Cidade). Nenhum dado excessivo (como CPF, telefone ou geolocalização precisa) deve ser solicitado.
- [ ] **Consentimento & Aceite no Cadastro:** Adicionar checkbox obrigatório no formulário de criação de conta (`/cadastrar`): *"Declaro que li e concordo com os Termos de Uso e a Política de Privacidade"*, com link direto abrindo em modal ou nova aba.
- [ ] **Base Legal & Segurança:** Salvar o consentimento com data/hora do aceite (`accepted_terms_at`) no registro do usuário.
- [ ] **Direito ao Esquecimento (Exclusão da Conta):** Disponibilizar no perfil do estudante um botão seguro de *"Excluir minha conta e meus dados"*, que remove ou anonimiza integralmente suas submissões, mantendo integridade referencial sem expor dados pessoais.

#### 3. Auditoria de Cookies & Diretriz de Scripts de Tracking
- [ ] **Zero Tracking Invasivo:** Manter a plataforma estritamente livre de ferramentas de espionagem de dados comerciais de terceiros (como Meta Pixel ou redes de ad tracking).
- [ ] **Auditoria de Cookies:** Assegurar que o sistema utilize exclusivamente **cookies estritamente necessários** (sessão do Rails: `_game_qta_session` criptografada, HttpOnly, SameSite=Lax).
- [ ] **Aviso de Cookies / Privacidade (Banner ou Footer Notifier):** Se não houver cookies de terceiros, exibir um aviso transparente e não invasivo informando que *"Utilizamos apenas cookies essenciais para o funcionamento seguro da sua sessão de jogo, de acordo com nossa Política de Privacidade"*. Caso analytics venha a ser instalado, implementar bloqueio condicional prévio (*opt-in*).

#### 4. Acessibilidade Digital (WCAG 2.1 Nível AA) & Correção de Contraste
- [ ] **Revisão de Contraste de Cores:** Auditar e ajustar todas as combinações da paleta `emerald` e textos `slate` contra fundos brancos/cinzas, garantindo a razão mínima de contraste de **4.5:1** para textos normais e **3:1** para elementos gráficos/botões (atendendo usuários com baixa visão ou daltonismo).
- [ ] **Navegação por Teclado:** Garantir ordem lógica de foco (`tabindex`), anéis de foco visíveis (`focus-visible:ring-2`) em todos os botões, links e alternativas de perguntas.
- [ ] **Acessibilidade para Leitores de Tela (Screen Readers):**
  - Textos alternativos descritivos (`alt="..."`) em todas as imagens (`ods-*.png`, `logo_qta.png`, `tekohalab.png`).
  - Atributos ARIA adequados (`aria-live="polite"` no cronômetro regressivo da questão, `role="dialog"` nos modais de erro/acerto, `aria-expanded` nos accordions do dashboard).
- [ ] **Semântica HTML:** Estruturar cabeçalhos corretos (`<h1>`, `<h2>`, `<main>`, `<nav>`, `<section>`).

---

## ⚡ PRIORIDADE 2: Melhorias Pedagógicas & Operacionais

*Recursos de alto impacto no aprendizado dos alunos e na produtividade dos administradores.*

- [ ] **Feedback Detalhado Pós-Erro ("Explicação do Professor"):**
  - *O quê:* Na tela de resultado ao errar uma questão, exibir um bloco explicativo detalhado informando o porquê de cada alternativa estar errada e a fundamentação legal correta.
  - *Por quê:* Transforma o erro em aprendizado ativo imediato, em vez de apenas uma tela punitiva de pontuação zerada.
- [ ] **Importação em Lote de Questões (Upload CSV):**
  - *O quê:* Permitir que o Administrador faça upload de uma planilha `.csv` contendo Nível, Tema, Enunciado, Vídeo, 4 Alternativas e Gabarito.
  - *Por quê:* Elimina o maior gargalo operacional do projeto, que é o cadastro manual de dezenas de questões via formulário web.
- [ ] **Trilhas de Auditoria (Logs do Backoffice):**
  - *O quê:* Registrar em tabela interna qual administrador criou/editou conteúdos ou realizou o bloqueio/desbloqueio de um estudante (com timestamp).
  - *Por quê:* Governança e transparência para a equipe docente da UESC.

---

## 🎮 PRIORIDADE 3: Gamificação Avançada & Retenção de Estudantes

*Mecânicas de jogo focadas em incentivar o retorno diário e engajamento contínuo.*

- [ ] **Streak Diário (Ofensiva de Estudos):**
  - *O quê:* Contador de dias consecutivos em que o aluno realizou ao menos um desafio (estilo Duolingo), com badge visual no lobby.
  - *Por quê:* Estimula o hábito diário de estudo contínuo de temas ambientais.
- [ ] **Sistema de Vidas / Energia:**
  - *O quê:* Limitar a quantidade de erros diários através de "corações" com recarga automática por tempo ou por revisão de temas anteriores.
  - *Por quê:* Aumenta a cautela e seriedade do estudante ao responder os desafios.
- [ ] **Dicas Compráveis (Mecânica 50/50):**
  - *O quê:* Permitir que o estudante gaste pontos do ranking para eliminar 2 alternativas incorretas em questões difíceis.
  - *Por quê:* Adiciona estratégia ao uso da pontuação acumulada.

---

## ✨ PRIORIDADE 4: Analytics Visual, UX & Conforto Tecnológico

*Melhorias de conveniência visual, relatórios gráficos e portabilidade.*

- [ ] **Gráficos Visuais no Dashboard Admin:**
  - *O quê:* Gráficos interativos (Chart.js / ApexCharts sem Node, via Importmap) exibindo evolução de cadastros e taxa de acerto por nível.
  - *Por quê:* Substitui números brutos por visualizações executivas rápidas para relatórios de extensão universitária.
- [ ] **Suporte a PWA Completo (Progressive Web App Instalável):**
  - *O quê:* Configuração refinada de service worker, cache de assets e tela de boas-vindas para permitir "Adicionar à Tela Inicial" no celular como aplicativo nativo.
  - *Por quê:* Facilita o acesso mobile dos alunos de escolas públicas.
- [ ] **Dark Mode (Modo Escuro):**
  - *O quê:* Suporte a tema escuro usando as classes `dark:` do Tailwind e persistência na preferência do usuário.
  - *Por quê:* Conforto visual para estudos noturnos.
- [ ] **Micro-interações e Celebrações Visuais:**
  - *O quê:* Animação com confetes (canvas-confetti via importmap) ao desbloquear um Nível ou alcançar o Top 3 do Ranking.
  - *Por quê:* Reforço positivo imediato pela conquista acadêmica.

---

## 📝 Como extrair e iniciar uma tarefa deste Backlog?

1. Selecione a tarefa no **topo da prioridade**.
2. Crie uma branch específica: `git checkout -b feature/nome-da-feature`.
3. Crie a pasta correspondente seguindo o padrão AI-SDD: `/ai-sdd/prd-[feature-slug]/` contendo `prd.md`, `design.md`, `techspec.md` e `tasks.md`.
4. Implemente seguindo estritamente as tarefas atômicas e valide com `bin/rails test`.
