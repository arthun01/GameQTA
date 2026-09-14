# Product Map: Plataforma Gamificada de Direito Ambiental

## Visão Geral
Plataforma educacional gamificada para o ensino de Direito Ambiental, focada na progressão de estudantes por níveis e na gestão e análise de desempenho via painel administrativo.

## Tipos de Usuário
1. **Estudante**: Usuário final que consome os vídeos, responde questões e compete no ranking.
2. **Administrador**: Gestor responsável pela criação de conteúdo (níveis, temas, questões), moderação e análise de relatórios.

## Fluxos: Estudante

### 1. Realizar Cadastro e Login
1. O estudante acessa a tela de boas-vindas e seleciona a opção de criar conta.
2. Preenche o formulário com: nome completo, e-mail, senha, idade, nível de ensino e cidade.
3. Confirma o cadastro, é autenticado e visualiza a tela principal de Níveis.

### 2. Navegar e Progredir nos Níveis
1. O estudante visualiza a tela com os Níveis do jogo e seu progresso atual.
2. Tenta acessar o próximo Nível, mas ele está bloqueado se o progresso no Nível atual for inferior a 70%.
3. Seleciona um Nível desbloqueado para acessar a lista de Temas correspondentes.

### 3. Resolver Desafios (Consumo e Resposta)
1. O estudante escolhe um Tema e inicia uma questão, momento em que o tempo de resolução começa a ser cronometrado.
2. Assiste a um curto vídeo explicativo sobre o assunto.
3. Visualiza o enunciado da questão (que tem nível de dificuldade: fácil, médio ou difícil) e seleciona uma resposta.
4. Confirma a resposta, é informado se acertou ou errou, e recebe um artigo de feedback explicando o motivo.
5. O sistema registra a conclusão, atualizando os pontos, o progresso percentual e o tempo total investido.

### 4. Consultar Ranking
1. O estudante entra na tela de Ranking.
2. Visualiza sua posição em relação aos outros jogadores, baseada primeiramente na taxa de acertos e porcentagem concluída.
3. Em caso de empate, o estudante com o menor tempo total investido assume a posição mais alta.

## Fluxos: Administrador

### 1. Acessar Painel Administrativo
1. O administrador entra em uma rota específica e restrita.
2. Realiza o login com e-mail e senha administrativos.
3. É redirecionado ao Dashboard com a visão geral da plataforma.

### 2. Gerenciar Estrutura de Conteúdo
1. O administrador acessa a área de currículo educacional.
2. Pode criar, editar ou excluir Níveis.
3. Cria Temas e os aloca dentro dos Níveis existentes.
4. Cria Questões fornecendo: o vídeo, o enunciado, as opções de resposta, o gabarito, o artigo de feedback e o nível de dificuldade (fácil/médio/difícil). A questão é alocada a um Tema.

### 3. Moderar Estudantes
1. O administrador navega até a lista de usuários (estudantes) cadastrados.
2. Pode visualizar detalhes da conta, bloquear acessos ou excluí-la se necessário.

### 4. Gerenciar Administradores
1. O administrador acessa a área de equipe.
2. Pode criar novos logins com perfil de Administrador para dividir a gestão da plataforma com outros membros.

### 5. Analisar e Exportar Relatórios
1. O administrador acessa a área de Relatórios Analíticos.
2. Configura filtros e visualiza dados agregados: ranking geral, taxa de acerto por questão, média de conclusão por nível, balanceamento de acertos por dificuldade e demografia (faixa etária e nível de ensino).
3. Seleciona a opção de exportar e faz o download das informações.

## Observações
- A validação da progressão de Nível é estrita (70% mínimo) e deve ser verificada a cada Tema concluído.
- O tempo cronometrado durante o fluxo "Resolver Desafios" é essencial para o ranking, e sua captura de forma limpa previne trapaças.
- O cadastro de estudantes é rápido e sem fricção (não exige verificação por link de e-mail), com foco na usabilidade para o público jovem.

