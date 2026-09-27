# Guia do Administrador (Backoffice)

Este manual é focado no mantenedor e operador da plataforma QTA. O painel administrativo é o centro de controle da experiência de aprendizagem.

## 1. Gestão de Conteúdo (Níveis, Temas e Questões)
O jogo segue uma sequência linear de aprendizado:
*   **Nível:** Representa a grande etapa acadêmica (Ex: "Introdução à Moderação").
*   **Tema:** Ficam dentro dos níveis e representam tópicos específicos (Ex: "Ética e Limites").
*   **Questão:** A unidade básica do jogo. Cada questão pertence a um Tema.

**⚠️ Importante sobre Questões:**
Ao cadastrar ou editar uma questão, você **deve cadastrar as alternativas**. O sistema **não vai deixar** você salvar a questão se você não marcar **exatamente UMA** alternativa como "Certa". Questões sem respostas certas ou com múltiplas certas impediriam a progressão dos alunos.

## 2. Moderação da Comunidade
No painel **Estudantes**, você tem acesso à lista completa de inscritos.

*   **Bloqueio em tempo real:** Se um usuário for identificado por comportamento malicioso (fraude, tentativas de spoofing de API), você pode localizá-lo na lista e clicar em **Bloquear**.
*   **Efeito Imediato:** Assim que o botão for clicado, o usuário é expulso do aplicativo (onde quer que esteja logado) e tem seus pontos imediatamente apagados do pódio público (Ranking). O desbloqueio o readmite, mas os pontos precisarão ser recriados organicamente (ao responder uma nova questão).

## 3. Inteligência Analítica & Relatórios
O **Dashboard** exibe dados macros da operação em tempo real (Total de Alunos, Média de Acertos Global e Temas Concluídos).

Para análise externa profunda (BI, Excel, PowerBI), acesse a aba **Relatórios**:
*   **Relatório de Estudantes:** Extrai um `.csv` com o nome, email, nível educacional, score, tempo gasto e status de bloqueio de todos os usuários.
*   **Relatório de Desempenho por Tópico:** Agrega o desempenho geral da comunidade. Ele indica quantas tentativas ocorreram em cada Tema específico e qual a taxa de acerto nele. *(Útil para o Game Designer perceber se um tema está muito difícil ou fácil e rebalanceá-lo).*

## 4. Gestão de Equipe (Admins)
Na aba **Equipe**, é possível convidar novos moderadores.
*   Por questões de segurança contra falhas humanas, **o sistema não permite que você delete a si próprio**, nem permite a **deleção do último administrador existente** (garantindo que o painel nunca fique "trancado por fora").
