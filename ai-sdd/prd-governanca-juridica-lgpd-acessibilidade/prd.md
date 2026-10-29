# PRD - Governança Jurídica, LGPD e Acessibilidade

## Visão Geral

O pacote corresponde aos quatro tópicos da prioridade 1 do [backlog](../system/backlog.md) e apoia a inclusão educacional prevista na [visão do produto](../system/vision.md). Seu objetivo é oferecer transparência, proteção de dados e acesso ao Game QTA por estudantes, responsáveis legais e administradores.

**Premissas confirmadas em 27/10/2026:** cadastro aberto ao público, possibilidade de participação de crianças menores de 12 anos e equipe do projeto como responsável informada. A identificação formal de quem exerce o papel de controlador permanece pendente; o vínculo com a UESC não define, por si só, esse papel. Não foi fornecido e-mail de privacidade. Hospedagem, retenção, contas inativas e backups também estão indefinidos.

**Atualização do tópico 2 — contexto escolar e pesquisa futura:** o usuário prefere consentimento do responsável, preservando uma experiência simples do jogo. O professor aplicará o projeto em escolas; idade, escolaridade e cidade foram apontadas como dados de interesse para eventual pesquisa futura pela UESC. O usuário esclareceu que não há pesquisa ou análises definidas neste momento e que provavelmente ainda não existe consentimento; a situação dos termos e do protocolo precisa ser confirmada com o professor. Não se presume autorização para reutilizar os dados, nem se altera automaticamente a identidade do controlador da aplicação por esse vínculo institucional.

A necessidade dos campos será avaliada por finalidade atual. A possibilidade genérica de pesquisa futura não será usada isoladamente para tornar campos obrigatórios ou justificar retenção indefinida. Uma eventual constituição de banco para pesquisas futuras deverá ter finalidade delimitada, governança, prazo/critério de guarda, regras de acesso e consentimento ou outra base cabível, além das exigências éticas aplicáveis. Essa decisão depende de planejamento do professor/UESC. O aceite dos documentos do jogo não autoriza pesquisas futuras.

A autorização dos responsáveis, quando aplicável ao uso educativo ou à pesquisa, será específica para a finalidade e verificada por procedimento real. O usuário indicou preferência por verificação presencial/escola; a escola ou o professor não substituem automaticamente o responsável legal. Não foi aprovada uma regra geral de bloqueio de todos os menores de 18 anos. O fluxo de autorização continua pendente de detalhamento; aceite, perfil e exclusão já possuem entrega técnica separada.

**Sequência:** 1. Termos e Privacidade → 2. Dados e Menores → 3. Cookies → 4. Acessibilidade. Cada tópico terá seus requisitos rastreados no design, na especificação técnica e nas tarefas antes da implementação. Este PRD descreve a entrega pretendida; não declara funcionalidades já disponíveis nem conformidade concluída.

## Objetivos

- **Transparência:** disponibilizar os dois documentos sem login, com identificação de versão e descrição de todas as categorias de dados e serviços externos encontrados no inventário.
- **Controle dos dados:** verificar aceite, exercício de direitos e exclusão em todos os cenários definidos para contas novas, existentes e de menores.
- **Privacidade:** demonstrar, por auditoria de navegação, que nenhuma tecnologia opcional sujeita a consentimento é acionada antes da autorização correspondente.
- **Acessibilidade:** verificar os critérios aplicáveis da WCAG 2.1 A e AA nas jornadas públicas, estudantis e administrativas, com evidências automáticas e manuais e pendências explicitadas.

## Histórias de Usuário

- Como **visitante**, eu quero consultar os termos e a política antes de criar uma conta para entender o serviço e o uso dos meus dados.
- Como **estudante**, eu quero saber quais informações são necessárias, controlar escolhas opcionais e solicitar correção ou exclusão para exercer meus direitos.
- Como **responsável legal**, eu quero entender a participação de uma criança e os procedimentos de autorização e atendimento para protegê-la.
- Como **participante com deficiência**, eu quero navegar, estudar e responder às questões com recursos acessíveis para participar da experiência educacional.
- Como **administrador**, eu quero conhecer as regras de acesso, exportação e atendimento para tratar os dados dentro das finalidades informadas.

## Requisitos Funcionais

### 1. Termos de Serviço e Política de Privacidade

- **RF-001:** Disponibilizar `/termos` e `/privacidade` sem autenticação, acessíveis a partir do cadastro, dos logins e da navegação das áreas autenticadas.
- **RF-002:** Apresentar documentos legíveis em celular e computador, com versão para impressão sem menus, sobreposições ou cortes de conteúdo.
- **RF-003:** Explicar nos termos a finalidade educacional, regras de participação, segurança da conta, moderação, conteúdo e serviços externos, encerramento e alterações do serviço. Não prometer aconselhamento jurídico individual nem afastar direitos legais do participante.
- **RF-004:** Descrever na política os dados efetivamente tratados: perfil e credenciais protegidas; respostas, desempenho e ranking; sessões, IP, informações do navegador e registros operacionais. Distinguir dados fornecidos de dados gerados e apresentar a finalidade e necessidade de cada categoria.
- **RF-005:** Informar os responsáveis identificados, acessos administrativos, exportações, destinatários externos e eventuais transferências internacionais confirmadas. Considerar YouTube e Google Fonts existentes, além da infraestrutura que vier a ser definida.
- **RF-006:** Explicar os direitos de confirmação, acesso, correção, anonimização, bloqueio, eliminação, informação sobre compartilhamento, portabilidade nos limites aplicáveis, oposição, revogação e revisão de decisões automatizadas quando cabíveis. Orientar estudantes e responsáveis sobre solicitação, verificação proporcional de identidade e acompanhamento pelo canal efetivamente disponibilizado.
- **RF-007:** Exibir versão e data de atualização de cada documento, comunicar mudanças relevantes e conservar a identificação das versões associadas aos aceites registrados.
- **RF-008:** Manter as minutas identificadas como pendentes de validação enquanto faltarem identidade formal, contato, bases legais ou definições operacionais necessárias. Não criar endereços fictícios nem apresentar solicitações como enviadas quando não existir canal funcional.

### 2. Proteção de Dados, Cadastro e Menores

- **RF-009:** Justificar por finalidade a necessidade dos campos atuais: nome, e-mail, senha, idade, escolaridade e cidade. Distinguir operação educativa, caracterização atual do público (se efetivamente definida) e pesquisa. Reduzir ou tornar opcional o que não for necessário; não acrescentar CPF, localização precisa, documentos ou biometria como exigência geral. A hipótese de pesquisa futura sem plano não torna obrigatória a coleta desses campos.
- **RF-010:** Exigir no cadastro manifestação desmarcada por padrão para concordância com os termos e ciência da política, com acesso aos textos sem perder os dados preenchidos. Rejeitar cadastro sem esse aceite, inclusive fora da interface visual.
- **RF-011:** Registrar data, hora e versões dos documentos aceitos. Distinguir esse registro de eventuais consentimentos específicos para tratamento de dados, participação de menores e tecnologias opcionais.
- **RF-012:** Tratar contas existentes sem atribuir aceites retroativos. Solicitar a manifestação necessária antes de retomar funcionalidades que dela dependam, preservando consulta aos documentos e exercício de direitos.
- **RF-013:** Definir a experiência por faixa etária, com linguagem adequada, proteção por padrão e mecanismos proporcionais de aferição de idade e participação dos responsáveis, conforme a legislação aplicável. Um campo de idade ou checkbox isolado não comprova autorização do responsável.
- **RF-014:** Quando a base aplicável exigir consentimento do responsável, impedir a ativação do tratamento dependente antes de autorização específica e verificável. Disponibilizar informação e procedimento para revogação, considerando seus efeitos. Distinguir autorização do uso educativo, consentimento para uma pesquisa ou banco formal e assentimento do participante, quando aplicável. Não presumir autorização da escola como consentimento do responsável. Base legal, mecanismo, registro e critérios de verificação deverão ser validados antes da disponibilização desse fluxo ao público.
- **RF-015:** Permitir solicitar acesso e correção por atendimento com identidade verificada, informando recebimento, resultado e justificativas nos prazos legais aplicáveis. Não expor dados de outros participantes durante o atendimento.
- **RF-016:** Disponibilizar ao estudante autenticado a ação de excluir a própria conta, com confirmação informada e verificação de identidade. Encerrar sessões e remover ou anonimizar irreversivelmente os dados associados, inclusive participação no ranking, impedindo recriação por processamento pendente.
- **RF-017:** Informar limites e prazos de exclusão em registros, backups e cópias exportadas, com tratamento das retenções legalmente justificadas e orientação aos destinatários sob responsabilidade do projeto. Não prometer apagamento imediato de cópias fora de seu controle.
- **RF-018:** Avaliar a exposição de nomes e desempenho no ranking e em relatórios, especialmente de menores, e limitar identificação e acesso à finalidade aprovada. Validar as bases legais por finalidade, sem assumir que o aceite geral autoriza todo tratamento. Acesso a dados para pesquisa dependerá do enquadramento e das autorizações aplicáveis ao estudo ou banco definido; pesquisas futuras não herdam automaticamente o aceite do jogo.

### 3. Cookies e Serviços de Terceiros

- **RF-019:** Inventariar cookies e tecnologias equivalentes, incluindo nome, origem, finalidade, duração, categoria e proteção. Conferir os cookies reais de sessão estudantil, administrativa e de navegação, sem assumir o nome exemplificado no backlog.
- **RF-020:** Manter o serviço sem publicidade comportamental, venda de dados ou rastreamento comercial invasivo. Qualquer futura inclusão de analytics exigirá nova avaliação de finalidade, base legal e escolhas do participante.
- **RF-021:** Proteger cookies de autenticação contra acesso por scripts, restringir seu envio entre sites e exigir transporte seguro em produção. Justificar sua duração e assegurar que o encerramento da sessão invalide o acesso correspondente.
- **RF-022:** Exibir aviso acessível sobre os cookies necessários, com acesso à política. Uma ação de fechar ou reconhecer o aviso não poderá representar consentimento para usos opcionais.
- **RF-023:** Se houver tecnologias opcionais baseadas em consentimento, mantê-las desligadas até autorização específica, oferecer rejeição com destaque equivalente e permitir revisão ou revogação posterior, sem bloquear o acesso aos documentos e às funções independentes delas.
- **RF-024:** Avaliar as conexões ao YouTube e ao Google Fonts antes de afirmar que só existem tecnologias necessárias. Eliminar conexões dispensáveis e impedir carregamentos opcionais dependentes de autorização antes dela, oferecendo alternativa que preserve o acesso ao conteúdo educacional.

### 4. Acessibilidade Digital

- **RF-025:** Garantir contraste mínimo de 4,5:1 para texto comum e 3:1 para texto grande e elementos visuais necessários à identificação de controles, observadas as exceções da WCAG. Não comunicar acerto, erro ou bloqueio somente por cor.
- **RF-026:** Permitir executar todas as ações por teclado, em ordem lógica e com foco visível, sem aprisionamento ou acionamento involuntário.
- **RF-027:** Fornecer nomes acessíveis, instruções e associação entre campos, rótulos e erros, preservando valores válidos após falhas de formulário.
- **RF-028:** Tornar modais, expansão de níveis e mensagens de resultado compreensíveis por leitores de tela. Gerenciar entrada e retorno de foco nos modais e comunicar seus estados e mudanças relevantes.
- **RF-029:** Comunicar o tempo restante sem anúncios contínuos que interrompam a leitura. Atender ao critério de tempo ajustável ou documentar uma exceção aplicável, com avaliação do impacto pedagógico e competitivo antes de alterar a mecânica.
- **RF-030:** Descrever imagens informativas, identificar imagens decorativas adequadamente e nomear players e controles. Verificar legendas e alternativas para conteúdos audiovisuais conforme os critérios aplicáveis.
- **RF-031:** Organizar páginas com títulos, regiões e hierarquia semântica, manter o conteúdo utilizável com ampliação e reorganização responsiva e oferecer acesso direto ao conteúdo principal.
- **RF-032:** Registrar verificação dos critérios A e AA aplicáveis, combinando ferramentas automáticas, teclado e leitor de tela nos fluxos críticos. Lacunas, inclusive em vídeos externos, impedem declarar conformidade integral enquanto não forem resolvidas.

## Experiência do Usuário

O visitante consulta os documentos antes do cadastro. O estudante recebe informações adequadas à sua idade e realiza os aceites aplicáveis; o responsável participa quando necessário. Depois, pode revisar escolhas e exercer direitos. A exclusão informa consequências, pede confirmação e encerra os acessos.

Os textos usarão português simples e a identidade Emerald existente, com resumos e navegação por assuntos. Acessibilidade será considerada desde as primeiras páginas e auditada de forma abrangente no tópico 4. Avisos e documentos não poderão ocultar ações essenciais ou induzir escolhas.

## Restrições de Alto Nível

- **Referências jurídicas:** considerar a [LGPD e orientações da ANPD](https://www.gov.br/anpd/pt-br/acesso-a-informacao/perguntas-frequentes), o [Enunciado nº 1/2023](https://bibliotecadigital.mj.gov.br/bitstream/1/10215/2/Enunciado_ANPD_2023_1.html), o [ECA Digital e regulamentação aplicável](https://www.gov.br/anpd/pt-br/assuntos/eca-digital) e o [guia de cookies](https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_orientativo_cookies_e_protecao_de_dados_pessoais). A avaliação deverá corresponder às finalidades e à operação concreta, com validação jurídica antes da publicação definitiva.
- **Referência de acessibilidade:** [WCAG 2.1 A e AA](https://www.w3.org/TR/WCAG21/), incluindo [tempo ajustável](https://www.w3.org/WAI/WCAG21/Understanding/timing-adjustable). Não presumir que ferramentas automáticas comprovam todos os critérios.
- **Decisões pendentes:** identificação formal do controlador; contato e atendimento; bases legais por finalidade; fluxo de menores; hospedagem, operadores e transferências; retenção de contas, logs, aceites e backups; tratamento de exportações; ajustes do ranking e cronômetro. Registrar decisão, responsável e validação nas etapas seguintes. Pendências podem permanecer no planejamento, mas precisam ser resolvidas antes da liberação das funcionalidades correspondentes ao público.
- **Entrega:** seguir AI-SDD na branch `rafael`, atualizar README e manuais afetados e demonstrar os requisitos implementados nos testes. Realizar revisão antes de abrir o PR para `main`, distinguindo novas entregas, limitações e problemas preexistentes.

## Fora de Escopo

- Funcionalidades das prioridades 2, 3 e 4 do backlog, como importação de questões, novas recompensas, analytics e modo escuro.
- Contratação de hospedagem, criação de caixas de e-mail e definição unilateral de identidade institucional ou bases legais.
- Elaboração unilateral de protocolo científico, aprovação ética ou criação de banco de pesquisa antes da definição de finalidade, governança e autorizações pelo professor/UESC. A governança documenta essa dependência; não presume pesquisa já autorizada.
- Atribuição automática de responsabilidade à UESC, certificação jurídica, declaração antecipada de conformidade ou publicação em produção nesta etapa.
- As minutas finais dos termos e da política, o design, a arquitetura e as tarefas de implementação serão elaborados nas etapas correspondentes; este documento define seus requisitos.
