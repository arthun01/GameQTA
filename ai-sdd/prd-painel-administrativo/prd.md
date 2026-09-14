# PRD - Painel Administrativo (Gestão de Conteúdo)

## Visão Geral

O Painel Administrativo de Gestão de Conteúdo é o módulo fundacional (Fase 1) da plataforma gamificada de Direito Ambiental. Ele resolve o problema do "catálogo vazio", fornecendo as ferramentas necessárias para que os educadores e administradores cadastrem, organizem e estruturem todo o material didático (vídeos, perguntas, artigos) em uma hierarquia de Níveis e Temas antes da entrada dos estudantes no ecossistema. É uma funcionalidade valiosa pois garante controle total sobre a trilha de aprendizado, permitindo que a administração conduza o jogo educacional de forma segura e organizada.

## Objetivos

- **Objetivo 1**: Fornecer um fluxo intuitivo de criação de hierarquia de conteúdo — Métrica: O administrador consegue criar a estrutura completa de Nível > Tema > Questão sem a necessidade de recorrer a manuais ou suporte técnico.
- **Objetivo 2**: Garantir a integridade pedagógica do jogo — Métrica: 100% das Questões cadastradas possuem, de forma validada, link de vídeo (YouTube), enunciado, opções com definição clara da resposta correta e artigo de feedback.

## Histórias de Usuário

- Como administrador, eu quero me autenticar no sistema de forma segura para ter acesso exclusivo às ferramentas de gestão.
- Como administrador, eu quero criar, ler, editar e excluir Níveis (informando nome, descrição e ícone) para desenhar os capítulos principais da jornada do estudante.
- Como administrador, eu quero associar múltiplos Temas a um Nível (com nome, descrição e ícone) para segmentar o conhecimento dentro de cada capítulo.
- Como administrador, eu quero adicionar Questões a um Tema, incluindo link do YouTube, opções de resposta, indicação da opção correta, nível de dificuldade e um artigo de feedback, para estruturar o desafio do aluno.

## Requisitos Funcionais

### Autenticação Administrativa
- **RF-001**: O sistema deve possuir uma rota de login exclusiva, distinta da interface pública de alunos, que valide e-mail e senha.
- **RF-002**: O sistema deve restringir o acesso a todas as áreas administrativas caso a sessão não esteja autenticada.

### Gestão de Níveis
- **RF-003**: O sistema deve permitir as operações de CRUD (Criar, Ler, Atualizar, Excluir) para a entidade Nível.
- **RF-004**: Ao criar ou editar um Nível, os campos obrigatórios devem ser: Nome, Descrição e Ícone.

### Gestão de Temas
- **RF-005**: O sistema deve permitir as operações de CRUD para a entidade Tema.
- **RF-006**: Ao cadastrar um Tema, o sistema deve exigir obrigatoriamente a associação a um Nível existente.
- **RF-007**: Ao criar ou editar um Tema, os campos obrigatórios devem ser: Nome, Descrição e Ícone.

### Gestão de Questões
- **RF-008**: O sistema deve permitir as operações de CRUD para a entidade Questão.
- **RF-009**: Ao cadastrar uma Questão, ela deve ser obrigatoriamente vinculada a um Tema.
- **RF-010**: O formulário de Questão deve conter os campos: Enunciado, Link do YouTube, Opções de Resposta, Artigo de Feedback e Nível de Dificuldade (Fácil, Médio, Difícil).
- **RF-011**: O sistema deve exigir a inclusão de no mínimo 2 e no máximo 5 opções de resposta por Questão.
- **RF-012**: O sistema deve validar que exatamente 1 (uma) opção seja marcada como a resposta correta antes de salvar o registro.

## Experiência do Usuário

- **Fluxos principais**: O administrador acessa a plataforma e visualiza os Níveis existentes dispostos de maneira visual (como "cartões" de um mundo de jogo). Ao clicar em um Nível, ele entra na camada inferior e visualiza os Temas ali dentro (drill-down). Clicando em um Tema, acessa as Questões. Em qualquer camada, há botões primários bem posicionados para adicionar novos itens.
- **Interações-chave**: Validações de formulário (ex: esquecer de marcar a opção correta na Questão) devem alertar o administrador no momento da submissão com clareza.
- **Diretrizes de UI/UX**: Para afastar a percepção de "painel administrativo frio", a interface usará a estética do jogo de forma simplificada (fontes, cores primárias, breadcrumbs navegacionais). A árvore conceitual (Nível > Tema > Questão) estará muito clara via navegação para que o gestor se sinta inserido na lógica do aluno.
- **Acessibilidade**: Contrastes adequados, textos legíveis e navegação via teclado com foco nos grandes blocos de texto (ex: edição do artigo de feedback).

## Restrições de Alto Nível

- **Integrações**: Hospedagem de vídeos é delegada ao YouTube. O sistema exigirá e usará apenas o link do vídeo para renderizar o player (iframe).
- **Performance**: O painel deve ser otimizado (paginação, Turbo frames) para carregar telas rapidamente mesmo que o sistema tenha centenas de questões em um tema.
- **Papéis Administrativos**: Por ora, existirá apenas um perfil unificado de Administrador com permissões irrestritas ao conteúdo.

## Fora de Escopo

- **Funcionalidades excluídas**: Módulo de dashboards estatísticos (gráficos, ranking admin), painel de exportação de dados, painel de moderação de estudantes e moderação de pontuação.
- **Considerações futuras**: Níveis de acesso granulares de administrador (ex: Super Admin, Criador de Conteúdo) e ferramentas de importação em massa (CSV).
- **Limites**: A interface "pública" de login do Aluno e o motor de gameplay de resolução de questões pertencem às Fases 2 e 3 e não estão cobertos nesta especificação.

