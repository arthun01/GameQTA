# PRD - Motor de Gameplay e Progressão do Estudante

## Visão Geral

Esta funcionalidade implementa o *core loop* (ciclo principal) do Game QTA, focado na jornada do estudante dentro dos Níveis e Temas. Ela resolve o desafio de entregar conteúdo denso de Direito Ambiental de forma estruturada e interativa, alternando entre momentos de consumo de vídeo e avaliação com limite de tempo e métricas de acerto. Para a plataforma, esta fase é o coração da experiência gamificada e pedagógica, garantindo que o estudante não avance na trilha de aprendizado (Níveis) sem comprovar a assimilação do conteúdo com um mínimo de 70% de aproveitamento.

## Objetivos

- **Objetivo 1**: Garantir um fluxo claro e sem distrações para o aprendizado e avaliação — Métrica: O usuário consegue acessar o vídeo, revelar a questão, responder e ver o feedback em uma mesma tela sem bloqueios de navegação.
- **Objetivo 2**: Assegurar o rigor pedagógico no avanço — Métrica: 100% dos avanços de Nível exigem uma taxa de acertos na primeira tentativa maior ou igual a 70% das questões exigidas.
- **Objetivo 3**: Medir a agilidade de resposta sem penalizar o aprendizado — Métrica: O tempo de resolução deve ser computado apenas a partir do momento em que o estudante clica para revelar a questão, ignorando o tempo que ele gasta assistindo ao vídeo de instrução.

## Histórias de Usuário

- Como estudante, eu quero visualizar um vídeo de instrução isoladamente antes da questão ser revelada para que eu possa estudar o assunto no meu próprio tempo sem a pressão do cronômetro.
- Como estudante, eu quero clicar em um botão para "Mostrar Questão" para que eu possa indicar que estou pronto para ser avaliado, iniciando o cronômetro naquele momento.
- Como estudante, eu quero visualizar um cronômetro regressivo claro enquanto respondo para que eu saiba quanto tempo resta antes da questão ser invalidada.
- Como estudante, ao responder de forma incorreta, eu quero que um popup exiba imediatamente uma explicação detalhada (artigo de feedback) e só então me permita seguir para a próxima questão, para que eu possa aprender com meu erro.
- Como estudante, ao terminar as questões do Nível, eu quero saber imediatamente se fui aprovado ou se precisarei recomeçar a trilha, para que meu aprendizado seja validado pedagogicamente.

## Requisitos Funcionais

### Dinâmica de Consumo e Avaliação
- **RF-001**: O sistema deve apresentar a tela do desafio dividida em duas etapas: inicialmente mostrando apenas o player de vídeo (embed do YouTube) e um botão "Mostrar Questão".
- **RF-002**: O sistema deve revelar o enunciado e as alternativas de resposta, simultaneamente iniciando um cronômetro regressivo visível ao usuário, somente após o clique no botão "Mostrar Questão".
- **RF-003**: O sistema deve expirar o desafio atualizando a submissão como "não respondida/errada" caso o tempo do cronômetro atinja zero e o usuário não tenha selecionado uma opção.
- **RF-004**: O sistema deve registrar, no momento da submissão da resposta, a exata fração de tempo transcorrida desde o clique de revelação até o clique da resposta para uso futuro no Ranking.

### Sistema de Feedback 
- **RF-005**: O sistema deve exibir um modal/popup de feedback instantâneo sobrepondo a interface sempre que o usuário submeter uma resposta incorreta.
- **RF-006**: O modal de feedback deve exibir a justificativa do erro baseada no artigo de feedback cadastrado no painel administrativo.
- **RF-007**: O usuário deve ter um botão de ação primária (ex: "Próxima Questão") dentro do modal de feedback para avançar apenas após reconhecer e ler o erro.

### Motor de Avaliação e Progresso
- **RF-008**: O sistema deve agrupar as respostas das questões de um Nível para calcular a taxa de acertos geral ao fim da sequência de Temas.
- **RF-009**: O sistema deve liberar o acesso ao próximo Nível da trilha de conhecimento se e somente se a taxa de acerto consolidada for igual ou superior a 70%.
- **RF-010**: O sistema deve reiniciar o progresso ("reset" da métrica de liberação) daquele Nível e exigir que o usuário responda as questões novamente caso a meta de 70% não seja atingida ao final.

## Experiência do Usuário

- **Fluxos principais**: O estudante clica em um Nível/Tema disponível. A tela inicializa com o vídeo e o botão de "Mostrar Questão". O aluno assiste. Após assistir, clica no botão. As alternativas aparecem em animação suave (ex: deslizar) e o cronômetro inicia. O aluno clica em uma alternativa. Se acertar, avança. Se errar, o popup (modal) aparece cobrindo a parte principal da interface, forçando a leitura da explicação antes de disponibilizar o botão de avanço. Ao final do Nível, uma tela de vitória ou de "Tente Novamente" (caso < 70%) é exibida.
- **Interações-chave**: Cronômetro visível com feedback de cores (ex: verde, amarelo, vermelho nos últimos segundos) no canto da interface (ex: superior direito). Bloqueio interativo no popup de feedback impedindo o avanço prematuro.
- **Diretrizes de UI/UX**: *Mobile-first* estrito, mantendo fontes grandes e fáceis de ler nas alternativas. O clique em opções de múltipla escolha deve ter "touch areas" amplas para não gerar cliques acidentais nos dispositivos móveis.
- **Acessibilidade**: Contraste elevado para a área do cronômetro; uso de modais acessíveis e clareza visual.

## Restrições de Alto Nível

- **Performance**: O fluxo de "Mostrar Questão" e de submissão da resposta não deve gerar recarregamento completo da página (page reload) que impacte o andamento do tempo e a concentração, favorecendo uma atualização de interface imediata e suave.
- **Conformidade**: O tempo computado precisa ser resistente a simples manipulações no frontend, prevenindo trapaças básicas que alterem a velocidade do cronômetro.
- **Dados**: Os tempos de resposta armazenados devem manter a precisão necessária para serem usados no desempate do ranking futuro.

## Fora de Escopo

- **Gamificação e Pontuação Global**: Não será implementado nesta fase o cálculo matemático de "Pontos" agregados ou a tela de Ranking Global que compara o tempo com outros usuários. Esta fase apenas capta o dado bruto. A exibição e cálculo do ranking ficam para a Fase 4.
- **Múltiplas Tentativas Retidas**: Se o aluno não atinge 70%, o sistema não retém acertos parciais. A progressão para a liberação daquele nível é reiniciada.
- **Seleção Dinâmica/Aleatória de Questões**: O escopo considera uma trilha lógica pré-definida. Algoritmos complexos de sorteio ou balanceamento de IA de questões estão excluídos.

