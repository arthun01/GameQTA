# PRD - Gamificação e Ranking Global

## Visão Geral

A funcionalidade de Gamificação e Ranking representa a implementação da Fase 4 do roadmap do produto. Ela tem como objetivo adicionar a camada competitiva essencial para sustentar o engajamento de longo prazo dos estudantes na plataforma de Direito Ambiental. A partir do volume de questões resolvidas nas fases anteriores, este sistema consolida o desempenho individual (acertos e tempo) em uma pontuação clara e os compara publicamente em um ranking global. Isso incentiva não só a assertividade ao responder, mas também a agilidade, fortalecendo a retenção na jornada educacional.

## Objetivos

- **Objetivo 1**: Engajar os estudantes recompensando a assertividade em diferentes complexidades — Métrica: 100% das questões respondidas corretamente devem computar pontos proporcionais à sua dificuldade cadastrada.
- **Objetivo 2**: Estimular a velocidade de raciocínio na resolução — Métrica: O tempo de resolução de cada questão deve ser acumulado e usado exclusivamente para fins precisos de desempate no ranking.
- **Objetivo 3**: Dar visibilidade competitiva ao ecossistema — Métrica: Todos os estudantes logados devem conseguir visualizar uma tabela única (Top 10) e identificar sua posição atual (mesmo fora do Top 10) em menos de 2 cliques a partir do dashboard.

## Histórias de Usuário

- Como **estudante**, eu quero ganhar pontos variados com base na dificuldade da questão resolvida (ex: fácil, médio, difícil) para que meu esforço em desafios complexos seja recompensado.
- Como **estudante**, eu quero visualizar os 10 primeiros colocados de toda a plataforma no ranking para entender qual o nível de excelência dos líderes.
- Como **estudante**, eu quero visualizar a minha própria posição no ranking geral, mesmo não estando no Top 10, para acompanhar minha evolução.
- Como **administrador**, eu quero que o ranking seja atualizado automaticamente para que não exija processamento manual da minha parte.

## Requisitos Funcionais

### Algoritmo de Pontuação
- **RF-001**: O sistema deve estabelecer uma tabela base de pontos para questões concluídas corretamente: Questão Fácil = 10 pontos; Questão Média = 20 pontos; Questão Difícil = 30 pontos.
- **RF-002**: O sistema não deve computar nenhuma pontuação para questões em que o estudante errou a resposta.
- **RF-003**: O sistema deve somar todos os pontos obtidos em questões acertadas para compor a Pontuação Total do estudante.

### Algoritmo de Desempate
- **RF-004**: O sistema deve calcular o Tempo Total Investido pelo estudante somando os tempos registrados de todas as tentativas finalizadas.
- **RF-005**: Em casos onde dois ou mais estudantes atinjam a mesma Pontuação Total, o sistema deve classificar na frente o estudante que possuir o menor Tempo Total Investido.

### Tela de Ranking
- **RF-006**: O sistema deve apresentar uma rota e tela específica de "Ranking", acessível no menu de navegação principal do estudante.
- **RF-007**: A tela deve exibir uma lista (tabela ou cartões) contendo estritamente os 10 melhores alunos da plataforma (Top 10), ordenados do 1º ao 10º lugar com base no RF-003 e RF-005.
- **RF-008**: Para os estudantes listados no Top 10, a visualização deve exibir a Posição, o Nome do Estudante e a Pontuação Total.
- **RF-009**: O sistema deve exibir a posição exata, nome e pontuação do estudante autenticado em uma seção fixada e destacada abaixo da lista principal, caso o mesmo não esteja classificado dentro do Top 10.

## Experiência do Usuário

- **Fluxos principais**: O estudante clica na opção "Ranking" no menu superior/lateral. A tela carrega mostrando diretamente o pódio e a lista até a 10ª posição. Na base da tela, uma barra fixa informa: "Sua Posição: Xº - X pontos".
- **Interações-chave**: Navegação passiva (sem necessidade de ações complexas além de visualizar). 
- **Diretrizes de UI/UX**: Destaque visual (cores diferenciadas, ícones de troféu ou medalhas) para os três primeiros colocados (1º, 2º e 3º). O layout deve ser amigável e focado, combinando com a simplicidade estipulada para o público jovem.
- **Acessibilidade**: Uso de constraste adequado e leitura de tela compatível nas linhas de classificação.

## Restrições de Alto Nível

- **Performance**: O cálculo da posição relativa e a geração do Top 10 devem ser otimizados, utilizando caches ou queries eficientes, para assegurar que a tela do ranking carregue rapidamente sem sobrecarregar o banco de dados conforme a massa de usuários cresce.
- **Dados**: O ranking será estritamente nominal e agregará a pontuação pública; detalhes privados como o e-mail do aluno não devem ser expostos na tela de Ranking.

## Fora de Escopo

- **Filtros e Segmentação**: Não haverá segmentação do ranking por turmas, níveis de ensino, estados ou cidades. O ranking é exclusivamente Global.
- **Conquistas/Insígnias (Badges)**: Não haverá geração de recompensas visuais (como medalhas de perfil ou badges por conclusão de fases) no momento.
- **Histórico e Evolução**: O sistema exibirá um "retrato" do ranking atual, não mantendo gráficos ou histórico para o estudante ver sua evolução ao longo de semanas/meses.
- **Recompensas físicas ou descontos**: O sistema não gerenciará premiações offline para o topo do ranking.
