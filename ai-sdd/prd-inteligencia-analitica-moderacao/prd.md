# PRD - Inteligência Analítica & Moderação

## Visão Geral

A funcionalidade de Inteligência Analítica e Moderação (Fase 5) entrega as ferramentas gerenciais definitivas para os educadores e administradores da plataforma. Ela resolve a necessidade de acompanhar o desempenho global da comunidade estudantil e manter a integridade do ambiente do jogo.
Direcionada à equipe interna (gestores, educadores e analistas de dados), a funcionalidade é valiosa porque converte o esforço de gamificação dos alunos em insights tangíveis de aprendizado e fornece autonomia para expandir a equipe e remover maus atores do sistema, fechando o ciclo operacional planejado na visão do produto.

## Objetivos

- **Objetivo 1**: Simplificar o acompanhamento gerencial — Métrica: Visualização instantânea de métricas consolidadas (sem tempo de carregamento perceptível para gráficos complexos).
- **Objetivo 2**: Prover autonomia analítica — Métrica: Capacidade de exportar a base de dados (alunos e temas) em arquivos `.csv` consistentes e sem dependência de acesso direto ao banco de dados.
- **Objetivo 3**: Garantir a integridade da competição — Métrica: Ação de bloqueio reflete instantaneamente na impossibilidade de login e remoção do ranking (tempo de efetivação < 1s).
- **Objetivo 4**: Escalar o backoffice — Métrica: Permite a criação imediata de novos administradores sem necessidade de integração com provedores de SMTP/Email.

## Histórias de Usuário

- Como **Gestor/Educador**, eu quero visualizar o total de alunos ativos e a média global de acertos na tela inicial do painel, para ter um panorama rápido do engajamento geral.
- Como **Analista de Dados**, eu quero exportar um relatório CSV focado em estudantes (trazendo informações individuais de placar e tempo), para cruzar dados e realizar análises aprofundadas no Excel/PowerBI.
- Como **Analista de Dados**, eu quero exportar um relatório CSV focado em Níveis e Temas (trazendo taxas de acerto e volumes de tentativa por assunto), para descobrir quais tópicos os alunos têm mais dificuldade.
- Como **Moderador**, eu quero poder bloquear a conta de um estudante permanentemente, para que ele perca imediatamente o acesso à plataforma e seu nome seja removido do Ranking Global.
- Como **Administrador Principal**, eu quero criar novos usuários com perfil de Admin definindo e-mail e senha manualmente, para adicionar colegas à equipe sem depender de envios de e-mail automatizados.

## Requisitos Funcionais

### Dashboard Analítico
- **RF-001**: O sistema deve exibir na tela inicial do painel administrativo cards com métricas consolidadas (ex: Total de Estudantes Cadastrados, Média Global de Acertos, Volume Total de Tentativas realizadas).
- **RF-002**: As métricas do dashboard devem refletir o estado atual do banco de dados, sendo calculadas de forma otimizada para evitar lentidão.

### Exportação de Dados (Relatórios CSV)
- **RF-003**: O sistema deve possuir uma funcionalidade de exportação "Desempenho Individual" que gera um arquivo `.csv`.
- **RF-004**: O CSV "Desempenho Individual" deve conter colunas com dados do aluno (Nome, E-mail, Cidade, Escolaridade) e resultados (Pontuação Total, Tempo Total).
- **RF-005**: O sistema deve possuir uma funcionalidade de exportação "Desempenho por Tópico" que gera um arquivo `.csv`.
- **RF-006**: O CSV "Desempenho por Tópico" deve agregar dados de sucesso por Tema/Nível (Nome do Tema, Total de Submissões, % de Acertos).

### Moderação de Estudantes
- **RF-007**: A listagem de estudantes no painel admin deve conter uma ação de "Bloquear" (e "Desbloquear") a conta.
- **RF-008**: Ao ser bloqueado, qualquer sessão ativa do estudante deve ser invalidada e novas tentativas de login devem retornar mensagem de erro ("Conta bloqueada").
- **RF-009**: Estudantes com o status de bloqueado devem ser automaticamente excluídos das consultas que montam o Ranking Global (Pódio).

### Gestão de Administradores
- **RF-010**: O painel deve listar todos os administradores cadastrados no sistema.
- **RF-011**: O sistema deve permitir a criação de um novo Administrador informando apenas `email_address` e `password` (senha inicial manual).
- **RF-012**: O sistema deve permitir a edição de um Administrador existente para resetar/modificar sua senha manualmente.

## Experiência do Usuário

- **Fluxos principais**:
  1. **Acompanhamento e Exportação**: Admin acessa a home do backoffice -> visualiza métricas em cards grandes no topo -> clica na aba "Relatórios" -> seleciona qual CSV deseja e o download inicia instantaneamente.
  2. **Moderação**: Admin acessa menu "Estudantes" -> busca pelo e-mail ou nome do infrator -> clica em "Bloquear" -> sistema pede confirmação via modal (Turbo Confirm) -> aluno recebe uma badge visual vermelha de "Bloqueado" na lista.
  3. **Adição de Equipe**: Admin acessa menu "Admins" -> clica em "Novo" -> preenche email e senha -> salva -> envia credenciais para o colega pelo Slack/WhatsApp.
- **Diretrizes de UI/UX**: Interface deve seguir o mesmo padrão Tailwind existente no painel (limpo, utilitário, com tabelas responsivas). Os botões de exportação devem ser bem destacados. Ações destrutivas (bloqueio) devem ter cores de alerta (vermelho).
- **Acessibilidade**: Contrastes adequados, mensagens claras após ações de bloqueio/exportação, e navegação plenamente utilizável via teclado no painel admin.

## Restrições de Alto Nível

- **Tecnologia**: A exportação CSV deve ser gerada utilizando a biblioteca padrão nativa do Ruby (`csv`).
- **Dados**: Relatórios exportados não devem incluir o hash das senhas ou dados sensíveis que não pertençam ao escopo educacional e demográfico.
- **Performance**: A geração de CSVs com muitos milhares de registros deve ser tratada preferencialmente com streaming de dados (`Enumerator`) ou carregamento em lotes (`find_each`) para não estourar a memória (OOM).
- **Integrações**: Nenhuma integração de e-mail (SMTP) ou envio de notificação push deve ser implementada nesta fase.

## Fora de Escopo

- **Funcionalidades excluídas**: 
  - Gráficos visuais (linhas, barras, de pizza) no Dashboard do painel.
  - Exportação em formatos `.xlsx`, `.pdf` ou layouts customizados.
  - Moderação branda (ex: suspensão temporária por X dias, shadowban parcial do ranking).
  - Envio de e-mails automáticos para estudantes informando do banimento.
  - Fluxo de "Esqueci minha senha" automático por e-mail para administradores.
- **Considerações futuras**: Dashboard visual interativo com bibliotecas JS (ex: Chart.js) e ferramentas de disparo de newsletter para os estudantes exportados.
- **Limites**: O reset de senhas de administradores depende puramente de outro administrador alterá-la via painel.
