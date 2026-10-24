# PRD - Refatoração de Design, UI/UX & Identidade Visual

## Visão Geral

Com a conclusão do núcleo funcional do MVP (Fases 1 a 5), a plataforma Game QTA alcançou estabilidade técnica e regras de negócio sólidas. No entanto, as interfaces iniciais utilizavam estilos genéricos e prototipados.

Esta funcionalidade (Fase 6 / Refatoração de Design) consolida a **identidade visual oficial** do Game QTA, criando uma experiência estética imersiva, moderna e acolhedora para o público jovem (estudantes do ensino fundamental e médio) e educadores. A iniciativa introduz a paleta temática *Emerald* (verde esmeralda, alinhado à temática ecológica e ambiental), nova tipografia, ilustrações minimalistas em formato quadrado para os níveis inspirados nos Objetivos de Desenvolvimento Sustentável (ODS), navbar de navegação, padronização do backoffice e reconhecimento institucional do **TekohaLab** e da **UESC** (Universidade Estadual de Santa Cruz).

- **Responsável Principal:** Ana Beatriz Guerra Mello (PR #17 — `ref-design`)
- **Status:** Concluído e integrado à branch `main`

## Objetivos

- **Objetivo 1**: Fortalecer a identidade de marca do jogo — Métrica: Substituição de elementos visuais genéricos pela logo oficial do Game QTA (`logo_qta.png`) e paleta de cores unificada *Emerald*.
- **Objetivo 2**: Elevar a usabilidade da "Sua Jornada" (Lobby do Aluno) — Métrica: Criação de Navbar superior para navegação rápida, numeração clara dos temas (ex: 1.1, 1.2) e layout responsivo.
- **Objetivo 3**: Humanizar e contextualizar os Níveis — Métrica: Inclusão de ilustrações minimalistas em formato quadrado (`ods-1.png` a `ods-5.png`) com proporções harmônicas.
- **Objetivo 4**: Padronizar o Painel Administrativo — Métrica: Coerência visual completa entre área pública e administrativa (sidebar, tabelas, botões e badges).
- **Objetivo 5**: Formalizar créditos institucionais — Métrica: Inclusão de rodapés elegantes destacando o projeto de extensão da UESC e a parceria com o TekohaLab.

## Histórias de Usuário

- Como **Estudante**, eu quero navegar em uma interface visualmente atraente com temática ambiental (tons de verde esmeralda e ilustrações temáticas), para me sentir em um jogo moderno e educativo.
- Como **Estudante**, eu quero ter uma Navbar superior na tela "Sua Jornada", para identificar rapidamente meu perfil, pontuação e acessar o ranking ou sair.
- Como **Estudante**, eu quero ver os temas claramente numerados dentro de cada nível, para entender a ordem pedagógica da trilha de aprendizado.
- Como **Estudante**, eu quero uma tela de resolução de questões com tipografia legível, botões de alternativa confortáveis e rodapé de créditos discreto, para focar nas perguntas sem distrações.
- Como **Administrador**, eu quero operar um painel gerencial com sidebar e tabelas padronizadas na mesma paleta esmeralda, garantindo sensação profissional e integrada com o restante do sistema.

## Requisitos Funcionais e Visuais

### 1. Identidade Visual Base & Autenticação
- **RF-001**: O sistema deve adotar a paleta *Tailwind Emerald* (`emerald-600`, `emerald-700`, `emerald-50`, etc.) como tom primário de ação, foco e destaque em todo o ecossistema.
- **RF-002**: A tela de cadastro (`/cadastrar`) deve exibir a logo oficial do QTA com centralização harmônica, campos com bordas arredondadas e estados de foco (*ring-emerald-500*).
- **RF-003**: A tela de login (`/entrar`) deve incorporar um rodapé institucional integrado conectando o Game QTA à UESC.
- **RF-004**: O arquivo `manifest.json.erb` do PWA deve ser atualizado com a cor tema `#059669` (Emerald 600) e os novos nomes oficiais da aplicação.

### 2. Tela "Sua Jornada" (Lobby do Jogador)
- **RF-005**: Inclusão de uma Navbar superior fixa/visível contendo saudação ao estudante, link direto para o Ranking, indicador de progresso e botão de encerramento de sessão.
- **RF-006**: Os cards de Nível devem exibir ilustrações minimalistas em PNG com proporção quadrada padronizada (`ods-1.png` a `ods-5.png`), eliminando distorções de escala.
- **RF-007**: Os temas pertencentes a cada nível devem ser explicitamente numerados de forma hierárquica (ex: "Tema 1.1", "Tema 1.2").
- **RF-008**: Rodapé da jornada com fundo integrado e transição suave de cores.

### 3. Tela de Gameplay (Resolução de Questões)
- **RF-009**: Reformulação do container de vídeo, espaçamento do enunciado e opções de resposta com efeitos de *hover* e *active* refinados.
- **RF-010**: Cartão de avaliação e feedback (`_evaluation.html.erb`) redesenhado com hierarquia visual clara entre acertos e erros.
- **RF-011**: Inclusão de rodapé com a marca e créditos do **TekohaLab** (`tekohalab.png`).

### 4. Backoffice Administrativo
- **RF-012**: Padronização da `_sidebar.html.erb` com badges, estados ativos e ícones alinhados aos tons de esmeralda e ardósia (*slate*).
- **RF-013**: Harmonização de tabelas e botões nas telas de Níveis, Estudantes, Admins, Relatórios e Dashboard.

## Critérios de Sucesso

1. Identidade visual uniforme em 100% das telas públicas e administrativas.
2. Imagens e ilustrações sem distorção em dispositivos móveis e desktops.
3. Testes automatizados (incluindo testes de sistema Capybara em `test/system/admin/admins_test.rb`) 100% aprovados com os novos seletores e textos.
