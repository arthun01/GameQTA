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

> **Status Atual:** MVP e Refatoração de Design concluídos (Fases 1 a 6). Adequação jurídica, proteção de dados e acessibilidade em andamento; existem decisões pendentes antes da publicação definitiva.

### 📍 O que TEMOS atualmente (Feito)

**Planejamento Estratégico (Metodologia AI-SDD):**
- [x] Visão do Produto (`ai-sdd/system/vision.md`)
- [x] Mapa de Produto (`ai-sdd/system/product_map.md`)
- [x] Roadmap Completo em 6 Fases (`ai-sdd/system/roadmap.md`)
- [x] **Fase 1 (Painel Admin):** PRD, Design, Tech Spec e Tasks (`ai-sdd/prd-painel-administrativo/`)
- [x] **Fase 2 (Onboarding):** PRD, Design no Paper, Tech Spec e Tasks (`ai-sdd/prd-onboarding-estudante/`)
- [x] **Fase 3 (Gameplay):** PRD, Design no Paper, Tech Spec e Tasks (`ai-sdd/prd-gameplay-estudante/`)
- [x] **Fase 4 (Gamificação):** PRD, Design no Paper, Tech Spec e Tasks (`ai-sdd/prd-gamificacao-ranking/`)
- [x] **Fase 5 (Moderação):** PRD, Tech Spec e Tasks (`ai-sdd/prd-inteligencia-analitica-moderacao/`)
- [x] **Fase 6 (Refatoração de Design & UI/UX):** PRD, Design, Tech Spec e Tasks (`ai-sdd/prd-refatoracao-design-ui/`)

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
- **Fase 6 — Refatoração de Design, UI/UX & Identidade Visual (100% Concluído — PR #17 por Ana Beatriz Guerra Mello):**
  - [x] **Tarefa 1.0:** Identidade Visual Base & Autenticação (Paleta Emerald `#059669`, logo oficial `logo_qta.png`, tela de cadastro responsiva e tela de login com rodapé integrado).
  - [x] **Tarefa 2.0:** Redesign da "Sua Jornada" (Navbar superior com perfil e atalho ao ranking, temas explicitamente numerados e ilustrações quadradas minimalistas dos níveis `ods-1.png` a `ods-5.png`).
  - [x] **Tarefa 3.0:** Interface de Gameplay e Rodapé Institucional (Resolução fluida de desafios, cartões de feedback visual pedagógico e assinatura institucional do TekohaLab / UESC com `tekohalab.png`).
  - [x] **Tarefa 4.0:** Padronização Visual do Painel Administrativo (Sidebar, tabelas, cards de métricas e formulários unificados na identidade visual; testes de sistema Capybara adaptados e 100% aprovados).

### 🚧 Próximos Passos (O que NÃO TEMOS)

- [ ] Concluir os quatro tópicos do [pacote de governança jurídica, LGPD e acessibilidade](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/prd.md), em sequência. A documentação está consolidada em versão 1.0; a execução operacional e as verificações de publicação continuam acompanhadas separadamente.
- [ ] Validação de campo (homologação) com alunos e professores da rede de ensino atendida pelo projeto de extensão da UESC.
- [ ] Planejamento e execução de itens da v2.0 a partir do [Backlog Estratégico](./ai-sdd/system/backlog.md) (como Sistema de Vidas/Energia, Streaks e Gráficos analíticos).

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

### Termos e Política de Privacidade — tópico 1

As páginas públicas **`/termos`** e **`/privacidade`** podem ser lidas sem login. Há links no cadastro, nos logins e nas áreas autenticadas, que abrem em nova aba para preservar formulários e partidas. Para imprimir ou salvar em PDF, use a opção **Imprimir** do navegador: a página mantém conteúdo, versão e data, ocultando a navegação.

Os textos públicos estão consolidados em **versão 1.0, de 04/11/2026**, com regras de participação, finalidades e fundamentos, dados, direitos, cookies, menores, terceiros e retenção. O responsável e atendente é **Guilhardes de Jesus Júnior**, no contato **guilhardesj@gmail.com**. A infraestrutura principal foi definida em VPS Hostinger no Brasil para aplicação, banco e backups. Isso não exclui tratamento internacional por fornecedores externos. O documento define regras de governança sem afirmar que todos os procedimentos estejam automatizados ou certificar conformidade integral.

O acompanhamento está no [PRD](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/prd.md), na [Tech Spec](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/techspec.md) e nas [tarefas](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/tasks.md). O usuário autorizou implementar a estrutura funcional antes do design do Paper, que poderá ser incorporado pelo colaborador posteriormente.

### Cadastro, perfil e exclusão — tópico 2 (parcial)

O cadastro público exige manifestação desmarcada por padrão sobre os termos e a política apresentados. O servidor conserva data, versões e cópia do texto; ele rejeita revisão desatualizada e não atribui aceites retroativos a contas antigas. Quando necessário, o estudante é direcionado para **`/aceite/new`** antes de voltar ao jogo. Isso não equivale a consentimento geral de tratamento nem a autorização do responsável.

**`/perfil`** permite consultar dados e o histórico de aceites, editar o cadastro com senha atual e excluir a própria conta com senha e confirmação das consequências. A exclusão remove dados da aplicação ativa (cadastro, sessões, tentativas, respostas, ranking e aceites). Jobs pendentes não restauram o ranking de contas excluídas ou bloqueadas. Os prazos de logs, backups e cópias exportadas estão definidos na política e no manual. Sua execução e as rotinas de descarte precisam de evidência operacional.

Idade, cidade e escolaridade são opcionais e podem ser apagadas do perfil. Sua finalidade atual aprovada é conhecer o público e orientar melhorias pedagógicas com relatórios agregados, protegendo grupos pequenos. O cadastro permanece direto, com as mesmas proteções para todos e sem aprovação externa geral. Essa experiência não substitui consentimento específico quando exigido, comprovação etária ou medidas aplicáveis de proteção de menores. O ranking usa códigos em lugar de nomes.

A regra aprovada prevê encerramento após 12 meses sem atividade autenticada, precedido de aviso por e-mail de pelo menos 30 dias. Sessões expiradas: até 30 dias; logs: até 90 dias; exportações: até concluir a tarefa, máximo 30 dias; atendimento: registro mínimo por 2 anos; backups/snapshots: até 30 dias. Incidentes seguem conservação mínima própria de 5 anos. As rotinas de inatividade, aviso e descarte não foram automatizadas nesta rodada.

O [manual](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/governanca-privacidade.md) e o [PDF completo](./output/pdf/game-qta-governanca-e-privacidade.pdf) reúnem as regras e os textos integrais. Ver [avaliação dos tratamentos](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/avaliacao-tratamentos.md), [atendimento](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/atendimento-privacidade.md) e [verificações de publicação](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/pendencias-publicacao.md). Pesquisa futura não recebe autorização pelo cadastro.

As mudanças de banco devem ser aplicadas com `bin/rails db:migrate`. Resultados de testes e limitações das auditorias estão no [acompanhamento da feature](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/tasks.md).

Para regenerar o dossiê a partir dos textos localizados, use Python com ReportLab e a fonte Liberation Serif instalada em `/usr/share/fonts/liberation-serif-fonts`:

```bash
mkdir -p tmp/pdfs
ruby -rjson -ryaml -e 'print JSON.pretty_generate(YAML.load_file("config/locales/pt-BR/legal.yml").fetch("pt-BR").fetch("legal_documents"))' > tmp/pdfs/legal_documents.json
python3 script/build_governance_pdf.py tmp/pdfs/legal_documents.json
```

O gerador combina o manual em Markdown com os textos integrais do locale. Revise as duas fontes e confira todas as páginas renderizadas antes de distribuir uma nova edição.

### Cookies e acessibilidade — tópicos 3 e 4

A sessão de acesso dura **12 horas**, com expiração também no servidor; em produção cookies usam Secure e o serviço força HTTPS. Google Fonts foi removido. Vídeos começam desligados e só conectam ao YouTube após **Assistir vídeo**, com aviso curto; é possível mostrar a questão diretamente ou desativar o player. Não existe autorização geral salva nem analytics instalado. O rodapé explica o uso sem bloquear a entrada.

**`/acessibilidade`** explica teclado, foco e limites conhecidos. Antes da revelação é possível escolher de **1 a 10× o tempo padrão**, para qualquer pessoa. A escolha é registrada no servidor e recarregar não reinicia o prazo; o tempo efetivo continua no desempate. Selecionar alternativa não envia a resposta: use **Confirmar resposta**. Diálogos usam foco nativo, Escape e títulos; formulários associam erros aos campos e respeitam preferência de reduzir movimento.

Evidências: [cookies](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/auditoria-cookies.md), [acessibilidade](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/auditoria-acessibilidade.md) e [decisões para publicação](./ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/pendencias-publicacao.md). A auditoria automática usa axe-core-capybara somente em testes, sem dependência no navegador de produção. Legendas/alternativas dos vídeos e avaliação humana com leitor de tela ainda dependem da equipe; não há certificação WCAG integral. A aprovação do PR não substitui as decisões jurídicas e operacionais pendentes.

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

## Correções do code review - 04/11/2026

Os 17 achados foram tratados na branch rafael. Consulte [correções e evidências](docs/reviews/2026-11-04-correcoes.md). Rails foi atualizado para 8.1.4.1, com auditoria atualizada sem vulnerabilidades conhecidas.

A aprovação da jornada é por nível, com todos os temas concluídos e no mínimo 70% das questões exigidas. O início retoma a tentativa ativa, a conclusão usa POST e os empates do ranking compartilham posição. O CSV de temas agora distingue Total_Tentativas de Total_Respostas; integrações com a planilha devem usar os novos cabeçalhos.

### Primeiro administrador e demonstração

A preparação normal do banco não cria credenciais públicas nem carrega dados de demonstração. Para provisionar um administrador, forneça BOOTSTRAP_ADMIN_EMAIL e BOOTSTRAP_ADMIN_PASSWORD por mecanismo seguro e execute bin/rails admins:create. A senha inicial deve ter pelo menos 12 caracteres e não é impressa. Instalações antigas com a credencial de demonstração precisam substituí-la e revogar sessões antes de exposição pública.

Demonstração exige desenvolvimento e opção explícita: LOAD_DEMO_DATA=1 bin/rails db:seed. Esse comando substitui conteúdo de demonstração e não deve ser executado em uma base com dados reais. O arquivo também recusa execução direta fora desse contexto.

### Entrega de recuperação de senha

Produção utiliza APP_HOST (somente o host, sem protocolo), MAILER_FROM, SMTP_ADDRESS, SMTP_PORT (padrão 587), SMTP_USERNAME, SMTP_PASSWORD e, se necessário, SMTP_AUTHENTICATION (padrão plain). O transporte exige STARTTLS. Valores devem vir da configuração segura do ambiente; não grave segredos no repositório. Configure um provedor real e confira o processamento dos jobs antes de usar a recuperação em produção. A validação local executa os jobs no adaptador de teste e não envia mensagens externas.

As correções não automatizam os avisos e descartes da política de retenção. A documentação de governança 1.0 e o PDF foram preservados.

## Consolidação das branches — 10/11/2026

A versão consolidada reúne a governança e as proteções de `rafael` com os ajustes de interface e pontuação de `arthur-testes`. As imagens ODS seguem a posição dos níveis, o avatar leva ao perfil, níveis/temas concluídos têm indicadores e os botões administrativos usam Emerald. Pontos por resposta são gravados; o total da conta acompanha o recálculo do ranking.

Também resolve as quatro pendências da segunda revisão: consulta sem instanciar todo o histórico, cadastro simultâneo com erro de formulário, restauração do ranking no desbloqueio e destinos de login independentes. Rejogar um tema aprovado mantém a conclusão anterior durante a tentativa; ao concluir, o novo resultado passa a valer, incluindo reset em caso de reprovação do nível.

Consulte a [comparação e decisões de consolidação](docs/reviews/2026-11-10-consolidacao-branches.md) e o [PRD de progressão e estabilidade](ai-sdd/prd-correcoes-progressao-e-estabilidade/prd.md). O PR #23 concentra a entrega das duas branches.

### Tempo automático e vídeo opcional

O jogo aplica o tempo padrão sem configuração por questão. Em `/perfil`, abra **Ajustar tempo de resposta** para salvar de 1 a 10 vezes esse tempo ou restaurar o padrão. A preferência fica na conta, sem pedido de diagnóstico ou senha adicional, e vale para próximas questões. Mudar a preferência ou recarregar não reinicia uma questão já revelada. O servidor usa o valor salvo, ignorando multiplicadores enviados pela tela de jogo.

Aplicar `bin/rails db:migrate` inclui a preferência com padrão 1 para contas existentes. Os documentos públicos e o PDF passam à versão **1.1, de 10/11/2026**, descrevendo o fluxo atual. A nova revisão exige nova manifestação pelo mecanismo de aceite existente e preserva registros anteriores.
