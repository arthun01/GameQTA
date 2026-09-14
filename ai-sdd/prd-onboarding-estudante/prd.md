# PRD - Onboarding e Interface do Estudante

## Visão Geral

A funcionalidade "Onboarding e Interface do Estudante" marca o início da Fase 2 do desenvolvimento do Game QTA. Com o motor de conteúdo (Painel Administrativo) já funcional, o objetivo agora é criar a porta de entrada para os alunos. O sistema resolverá a barreira de acesso criando um ambiente lúdico, *mobile-first* e gamificado desde o primeiro toque na tela. Os alunos se cadastrarão informando dados demográficos chave e terão acesso ao seu "Lobby/Dashboard", um mapa interativo onde visualizarão sua trilha de aprendizado (Níveis e Temas) e entenderão, visualmente, os bloqueios e desafios que têm pela frente.

## Objetivos

- **Objetivo 1**: Capturar dados demográficos essenciais dos alunos durante o cadastro — Métrica: 100% das contas novas devem possuir idade, cidade e nível de ensino válidos (padronizados).
- **Objetivo 2**: Apresentar a jornada do jogo de forma instigante — Métrica: Garantir que a lista de temas dos níveis bloqueados seja visualizável, servindo como "teaser" para o avanço no jogo.
- **Objetivo 3**: Impor as restrições mecânicas de nivelamento inicial — Métrica: O sistema deve garantir que contas recém-criadas tenham acesso de "Play" estritamente restrito ao Nível 1.

## Histórias de Usuário

- Como **Estudante**, eu quero preencher um formulário lúdico com meus dados (nome, idade, etc) e criar uma senha para que eu possa salvar meu progresso de forma segura.
- Como **Estudante**, eu quero fazer login na minha conta para retomar meu aprendizado exatamente de onde parei.
- Como **Estudante**, eu quero visualizar um painel (como um mapa) com todos os Níveis do jogo ordenados, para entender o tamanho e o percurso da minha jornada.
- Como **Estudante**, eu quero ver um cadeado (ou indicativo visual claro) nos Níveis que ainda não posso jogar, para saber que preciso cumprir uma meta antes de prosseguir.
- Como **Estudante**, eu quero poder clicar em um Nível bloqueado para ver quais Temas ele contém, para que minha curiosidade seja estimulada a continuar jogando até liberá-lo.

## Requisitos Funcionais

### Cadastro e Autenticação do Aluno
- **RF-001**: O sistema deve prover uma tela de cadastro de estudante independente da autenticação administrativa, requerendo E-mail (único), Senha, Nome Completo, Idade, Cidade e Nível de Ensino.
- **RF-002**: O campo "Nível de Ensino" deve obrigatoriamente ser uma seleção em lista (dropdown/select) restrita às opções: *Ensino Fundamental Incompleto, Ensino Fundamental Completo, Ensino Médio Incompleto, Ensino Médio Completo, Ensino Técnico, Ensino Superior Incompleto, Ensino Superior Completo*.
- **RF-003**: O sistema deve prover uma tela de login exclusivo para estudantes utilizando e-mail e senha.
- **RF-004**: O sistema deve proteger rotas privadas do estudante (como o Dashboard de níveis), exigindo que a sessão esteja ativa.

### Dashboard (Lobby / Mapa do Jogo)
- **RF-005**: O sistema deve listar todos os Níveis ativos criados pelos administradores em formato de listagem (cards ou mapa visual).
- **RF-006**: Por regra de negócio (MVP), o sistema deve classificar apenas o "Nível 1" (ou o primeiro nível de menor ordem de ordenação) como "Desbloqueado" para estudantes que não têm histórico de jogo (recém-cadastrados).
- **RF-007**: O sistema deve classificar os demais níveis como "Bloqueados", impedindo a ação de iniciar/jogar suas questões.

### Interação com Conteúdo Bloqueado
- **RF-008**: O sistema deve exibir o estado bloqueado visualmente de forma clara (ex: com ícone de cadeado e um tooltip ou texto explicando a regra dos 70%).
- **RF-009**: O sistema deve permitir que um estudante clique em um nível bloqueado e visualize (modo somente leitura) a lista de Temas daquele Nível.

## Experiência do Usuário

- **Diretrizes de UI/UX**: Abordagem primariamente **Mobile-first** (uma vez que os jovens acessarão majoritariamente via smartphones). 
- **Lúdico e Vibrante**: Telas de login e cadastro devem fugir do padrão corporativo; usar cores da natureza (tons de verde ambiental, terrosos, água), tipografia arredondada e layout amigável que transpareça que trata-se de um jogo, não de um formulário de faculdade.
- **Interações-chave**: Ao clicar em um Nível bloqueado, uma animação fluida (como um modal, bottom sheet no celular ou página aninhada) deve apresentar os temas futuros, reforçando a mensagem "Alcance 70% no nível anterior para liberar".

## Restrições de Alto Nível

- **Segurança de Sessão**: O escopo de autenticação do Aluno e do Administrador não devem se misturar de forma alguma; cookies e tokens de um não podem, em nenhuma hipótese, dar acesso a áreas restritas do outro.
- **Design Web Responsive**: O uso exclusivo do navegador (sem aplicativos nativos nas lojas) exige que a usabilidade móvel pareça "nativa" (botões largos, sem zoom inadequado nos campos de input do celular).

## Fora de Escopo

- **A Tela de Jogo (Gameplay)**: A execução de fato do jogo (carregar o player do YouTube, mostrar as opções de A a D, receber a resposta e mostrar o artigo de feedback) não faz parte deste PRD (pertence à Fase 3). Aqui estamos construindo a "sala de espera".
- **Cálculo Real de Progresso**: O motor que lê as respostas, calcula a nota real do aluno em tempo real e desbloqueia dinamicamente o Nível 2 pertence à Fase 3 e Fase 4. Para a Fase 2 (este PRD), o Nível 2 sempre estará bloqueado visualmente como demonstração mecânica.
- **Tabelas de Liderança (Rankings Globais)**: Pertencem à Fase 4.

