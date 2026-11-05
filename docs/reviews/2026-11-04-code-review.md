# Relatório de revisão de código - Game QTA

**Acompanhamento:** os achados deste snapshot foram tratados posteriormente. Veja [correções e validação de 04/11/2026](2026-11-04-correcoes.md). O conteúdo abaixo preserva as evidências da revisão original.

**Data:** 04/11/2026

**Branch:** rafael

**Commit analisado:** `10741c9b54fd47c402d89b88f45170fb55cff7a7`

**Método:** revisão técnica assistida por IA, com verificações locais e leitura em dois eixos.

## 1. Parecer e escopo

Esta revisão avaliou o estado completo do Game QTA na branch rafael, incluindo código anterior ao pacote de governança. Foram identificados 17 problemas relevantes: 7 de alta prioridade (P1) e 10 de prioridade média (P2). Recomenda-se tratar os P1 antes da publicação em produção.

A análise combinou leitura de código e documentação, revisão independente dos eixos Standards e Spec, verificações automatizadas e testes temporários de reprodução. Os 13 cenários temporários cobrem 12 achados; R17 possui dois cenários. Os testes confirmam a presença das falhas descritas, não a sua correção. Casos de concorrência foram analisados por inspeção, sem execução simultânea com duas conexões.

O trabalho não incluiu correções de código, implantação, teste de invasão em produção, exploração dos 21 advisories ou certificação jurídica/de acessibilidade. Testes existentes aprovados não eliminam falhas fora da cobertura. As conclusões se aplicam ao commit registrado; mudanças posteriores exigem revalidação. As decisões jurídicas e operacionais já documentadas no projeto permanecem fora do parecer técnico deste relatório.

### Prioridades

- **P1 - alta:** tratar antes da publicação; risco relevante de acesso, segurança ou regra central do jogo.
- **P2 - média:** corrigir falhas funcionais, integridade, abuso ou concorrência; não representa ausência de impacto.

| Eixo | P1 | P2 | Total |
|---|---:|---:|---:|
| Standards - implementação | 4 | 6 | 10 |
| Spec - regras do produto | 3 | 4 | 7 |
| Total | 7 | 10 | 17 |

## 2. Evidências de execução

| Verificação | Resultado |
|---|---|
| RuboCop | 139 arquivos; nenhuma infração. |
| Brakeman 8.1.0 | 79 verificações; zero alertas e zero erros. |
| Testes da aplicação | 105 testes; 654 assertions; zero falhas, erros ou skips. |
| Testes de navegador | 30 testes; 197 assertions; zero falhas, erros ou skips. |
| Reproduções temporárias | 13 cenários; 55 assertions; resultados confirmados no banco de testes. |
| Bundler-audit atualizado | Reprovado: 21 avisos para versões instaladas de componentes Rails. |
| Importmap audit | Nenhum pacote vulnerável encontrado. |

A base ruby-advisory-db foi atualizada para `516ea4757d5eec778c49af8371c23309c4b70f42`. A primeira consulta com a base anterior não apontou avisos; o resultado válido para o encerramento desta revisão é o da base atualizada: **21 avisos**. O total de advisories não equivale a 21 explorações demonstradas na aplicação.

## 3. Achados - Standards

### R01 - [P1] Credencial administrativa conhecida no preparo de produção

**Referências:** [db/seeds.rb:22](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/db/seeds.rb#L22), [bin/docker-entrypoint:5](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/bin/docker-entrypoint#L5).

**Evidência:** Inspeção do código e do caminho de inicialização; nenhum seed foi executado na revisão.

**Constatação:** Os seeds criam um administrador com senha fixa presente no repositório, imprimem as credenciais e não possuem restrição de ambiente. O entrypoint executa db:prepare ao iniciar o servidor; a preparação de um banco novo pode carregar esses seeds.

**Impacto:** Uma implantação que use esse bootstrap pode disponibilizar acesso administrativo com credencial conhecida. Os seeds também contêm rotinas destrutivas, inadequadas para uso indiscriminado com dados reais.

**Recomendação:** Separar dados de demonstração de provisionamento de produção. Exigir uma credencial inicial externa ou gerada com segurança, sem registrá-la nos logs; impedir limpeza automática de dados de produção.

**Critério de aceite:** Preparar um banco de produção vazio em ambiente isolado sem criar credencial pública, sem imprimir senha e sem permitir a rotina de demonstração sobre dados reais.

### R02 - [P1] Componentes do Rails com avisos de segurança publicados em 04/11

**Referências:** [Gemfile.lock:244](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/Gemfile.lock#L244), [Gemfile:4](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/Gemfile#L4).

**Evidência:** Bundler-audit com base ruby-advisory-db atualizada para 516ea47; 21 avisos identificados.

**Constatação:** O lockfile fixa Rails e seus componentes em 8.1.3.1. A base consultada em 04/11/2026 informa correções a partir de 8.1.4.1 na linha 8.1, incluindo avisos de RemoteIp, renderização e Active Storage.

**Impacto:** Existem dependências em versões afetadas por advisories. A explorabilidade depende dos recursos usados e da infraestrutura; não foi comprovada exploração de todos os avisos. O problema de RemoteIp pode afetar limites por IP sob determinadas configurações de proxy.

**Recomendação:** Atualizar o conjunto Rails de forma compatível, revisar as condições dos advisories e repetir segurança e testes. Não ignorar avisos apenas para obter aprovação.

**Critério de aceite:** Executar bundler-audit check --update com resultado aprovado ou justificativa técnica individual quando cabível, verificar proxy e rodar as suítes após o upgrade. A lista de 21 avisos está no Apêndice A.

### R03 - [P1] E-mail de recuperação de senha falha na renderização

**Referências:** [app/views/passwords_mailer/reset.text.erb:2](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/views/passwords_mailer/reset.text.erb#L2), [app/views/passwords_mailer/reset.html.erb:3](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/views/passwords_mailer/reset.html.erb#L3), [config/routes.rb:10](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/config/routes.rb#L10).

**Evidência:** Reproduzido: a renderização do corpo lança ActionView::Template::Error referente a edit_password_url.

**Constatação:** Os dois formatos de e-mail usam edit_password_url, enquanto a rota administrativa disponível fornece edit_admin_password_url. A solicitação apenas enfileira a mensagem e apresenta aviso de envio.

**Impacto:** A recuperação administrativa não entrega uma mensagem utilizável, embora a interface sinalize que as instruções foram solicitadas.

**Recomendação:** Corrigir os helpers nos dois templates. Configurar host e remetente reais antes de produção e testar o corpo e a entrega, além do enfileiramento.

**Critério de aceite:** Renderizar HTML e texto sem exceção e conferir URL administrativa, token e destino. Executar o job no ambiente de teste e validar a mensagem resultante.

### R04 - [P1] Alteração de senha conserva sessões administrativas anteriores

**Referências:** [app/controllers/admin/passwords_controller.rb:20](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/admin/passwords_controller.rb#L20), [app/controllers/admin/admins_controller.rb:26](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/admin/admins_controller.rb#L26).

**Evidência:** Reproduzido: cookie anterior continuou acessando o dashboard após reset bem-sucedido.

**Constatação:** Os fluxos atualizam a senha do administrador sem destruir as sessões vinculadas à conta. O cookie anterior permanece autorizado dentro da validade de 12 horas.

**Impacto:** Recuperar ou trocar a senha não retira o acesso de quem já possua uma sessão comprometida.

**Recomendação:** Revogar as sessões na mesma operação transacional de mudança efetiva de senha, tratando também alterações realizadas pela gestão de administradores.

**Critério de aceite:** Autenticar em duas sessões, alterar/resetar a senha e comprovar que ambas as credenciais de sessão anteriores deixam de acessar páginas administrativas.

### R05 - [P2] Campos de estudantes chegam ao CSV como fórmulas de planilha

**Referências:** [app/controllers/admin/reports_controller.rb:24](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/admin/reports_controller.rb#L24).

**Evidência:** Reproduzido: nome =1+1 e cidade =2+2 preservados como valores de células no CSV.

**Constatação:** Nome e cidade são controlados pelo participante e exportados diretamente. CSV.generate_line protege a sintaxe do formato, mas não impede interpretação como fórmula pelo programa de planilha.

**Impacto:** Abrir o arquivo em Excel ou Calc pode interpretar conteúdo fornecido por um estudante como fórmula. Os efeitos dependem das funções e configurações do consumidor.

**Recomendação:** Neutralizar fórmulas nos campos textuais da exportação conforme o consumidor previsto e testar os prefixos e caracteres relevantes. Não presumir que aspas CSV bastam.

**Critério de aceite:** Validar casos iniciados por =, +, - e @, além de controles relevantes, no consumidor escolhido e em reimportações. Conferir a referência OWASP, que ressalta diferenças entre programas.

### R06 - [P2] Reset com senha vazia informa sucesso sem alterar a credencial

**Referências:** [app/controllers/admin/passwords_controller.rb:20](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/admin/passwords_controller.rb#L20).

**Evidência:** Reproduzido: resposta de sucesso com digest preservado e token de reset ainda válido.

**Constatação:** O endpoint permite enviar password e password_confirmation vazios. No registro existente, has_secure_password não substitui a senha por uma string vazia e a atualização pode retornar sucesso.

**Impacto:** O usuário recebe confirmação de reset, mas a credencial antiga continua válida. A mensagem não corresponde ao resultado da operação.

**Recomendação:** Exigir nova senha não vazia e confirmação válida especificamente no fluxo de recuperação, sem alterar a regra de edição opcional de senha em outros formulários.

**Critério de aceite:** Rejeitar parâmetros ausentes ou vazios com mensagem clara; aceitar apenas uma mudança efetiva. Validar a invalidação do token após reset real.

### R07 - [P2] E-mail administrativo sem validações de domínio

**Referências:** [app/models/admin.rb:1](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/models/admin.rb#L1).

**Evidência:** Reproduzido: cadastro com e-mail duplicado causa ActiveRecord::RecordNotUnique.

**Constatação:** Admin normaliza o e-mail, mas não valida presença, formato ou unicidade. Uma duplicidade atinge o índice único do banco em vez de retornar erros do formulário.

**Impacto:** Criação ou edição pode produzir erro interno; valores vazios ou inválidos também podem escapar da validação do navegador em requisições diretas.

**Recomendação:** Adicionar validações no model, conservar a proteção única do banco e tratar adequadamente conflitos concorrentes.

**Critério de aceite:** Cobrir criação e edição com e-mail duplicado, vazio e inválido. O formulário deve retornar erro tratável, sem persistir a alteração e sem resposta 500.

### R08 - [P2] Solicitação pública de recuperação sem limite na aplicação

**Referências:** [app/controllers/admin/passwords_controller.rb:8](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/admin/passwords_controller.rb#L8).

**Evidência:** Inspeção: não existe rate_limit nesse endpoint; a autenticação é dispensada.

**Constatação:** Repetir a solicitação para um endereço administrativo conhecido pode enfileirar sucessivas mensagens sem limitação implementada nesse fluxo.

**Impacto:** Há risco de abuso da fila e envio repetitivo de e-mails quando a entrega estiver funcional. Não foi verificada proteção adicional de infraestrutura.

**Recomendação:** Limitar solicitações por origem e destinatário, mantendo resposta indistinguível para endereços existentes e inexistentes.

**Critério de aceite:** Com armazenamento de rate limit ativo no teste apropriado, exceder o limite configurado e comprovar que novas mensagens não são enfileiradas durante a janela.

### R09 - [P2] Exclusões concorrentes podem remover todos os administradores

**Referências:** [app/controllers/admin/admins_controller.rb:34](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/admin/admins_controller.rb#L34).

**Evidência:** Inspeção de concorrência; não foi executado teste simultâneo com duas conexões.

**Constatação:** A verificação de Admin.count e a exclusão não são serializadas. Com dois administradores, requisições de A para excluir B e de B para excluir A podem ambas observar count=2 antes de remover seus alvos.

**Impacto:** O sistema pode terminar sem administrador. Destruir sessões não interrompe uma requisição que já foi autenticada.

**Recomendação:** Usar uma estratégia de lock compartilhada por todas as exclusões, recontando dentro da mesma transação. Um lock somente no alvo não protege alvos diferentes.

**Critério de aceite:** Testar duas conexões concorrentes e comprovar que pelo menos um administrador permanece e que a solicitação recusada recebe resposta clara.

### R10 - [P2] Exclusão recusada de nível é anunciada como concluída

**Referências:** [app/controllers/admin/levels_controller.rb:35](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/admin/levels_controller.rb#L35).

**Evidência:** Reproduzido: nível com temas preservado, acompanhado de mensagem de remoção bem-sucedida.

**Constatação:** Level restringe exclusão quando possui temas, mas o controller ignora o retorno de destroy e sempre redireciona com aviso de sucesso.

**Impacto:** A interface fornece resultado falso ao administrador e dificulta compreender a restrição de integridade.

**Recomendação:** Verificar o resultado da exclusão e apresentar os erros ou uma orientação coerente. Preservar a restrição quando houver dependências.

**Critério de aceite:** Excluir nível vazio com sucesso e tentar excluir nível com temas, confirmando que ele permanece e que a mensagem informa a recusa.

## 4. Achados - Spec

### R11 - [P1] Servidor permite iniciar conteúdo de níveis bloqueados

**Referências:** [app/controllers/play/themes_controller.rb:3](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/play/themes_controller.rb#L3).

**Evidência:** Reproduzido: POST direto iniciou um tema de nível não liberado pela jornada.

**Constatação:** A ação start busca o tema por ID e cria a tentativa sem validar o desbloqueio do nível ou a progressão do estudante.

**Impacto:** A restrição visual pode ser contornada por requisição direta, contrariando o requisito de avanço condicionado a aproveitamento mínimo.

**Recomendação:** Centralizar a disponibilidade por estudante no domínio e aplicá-la às operações que dependem dessa autorização, sem confiar apenas na interface.

**Critério de aceite:** Uma conta sem progresso deve ser impedida de iniciar conteúdo bloqueado; uma conta com pré-requisitos cumpridos deve conseguir iniciar. Cobrir requisições fora da interface.

### R12 - [P1] Aprovação não libera o próximo nível na jornada

**Referências:** [app/views/dashboard/index.html.erb:39](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/views/dashboard/index.html.erb#L39), [app/models/level.rb:7](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/models/level.rb#L7).

**Evidência:** Reproduzido: primeiro nível integralmente aprovado e próximo nível ainda exibido como bloqueado.

**Constatação:** A jornada usa somente level.starting_level?, que compara o registro ao primeiro nível global. A condição não considera o estudante nem suas aprovações.

**Impacto:** O caminho normal de navegação fica preso no primeiro nível, mesmo após cumprir a meta pedagógica.

**Recomendação:** Calcular a disponibilidade de cada nível com base em progresso e conclusão válidos dos anteriores. Reutilizar a mesma regra no servidor e na apresentação.

**Critério de aceite:** Aprovar o primeiro nível e verificar liberação do segundo; repetir nos seguintes e garantir bloqueio quando a meta não for alcançada.

### R13 - [P1] Conclusão prematura permite aprovação com questões omitidas

**Referências:** [app/controllers/play/themes_controller.rb:22](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/play/themes_controller.rb#L22), [app/models/level.rb:20](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/models/level.rb#L20).

**Evidência:** Reproduzido: uma resposta correta entre duas questões do tema resultou em aprovação com nota 100%.

**Constatação:** finish marca a tentativa como concluída sem conferir pendências. score_for divide os acertos pelas submissões existentes, deixando questões e temas não respondidos fora do denominador.

**Impacto:** É possível obter aprovação sem cumprir a sequência de avaliação. A nota exibida não representa o aproveitamento sobre o conteúdo exigido.

**Recomendação:** Exigir conclusão integral, calcular sobre todas as questões exigidas e realizar a transição de estado de modo protegido, transacional e idempotente. Evitar mutação de estado por GET.

**Critério de aceite:** Tentar concluir com questões não reveladas, reveladas sem resposta e temas omitidos deve ser recusado. Somente a conclusão válida permite calcular aprovação.

### R14 - [P2] Reset de progresso não invalida pontuação do ranking

**Referências:** [app/models/question_submission.rb:9](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/models/question_submission.rb#L9), [app/models/level.rb:29](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/models/level.rb#L29).

**Evidência:** Reproduzido: dados removidos, nenhum novo job enfileirado e pontuação antiga mantida até recálculo manual.

**Constatação:** O callback de atualização cobre criação e edição, mas não remoção. Se o job anterior executar antes do reset, o ranking conserva valores de respostas que já não existem.

**Impacto:** Pontuação e tempo deixam de corresponder aos dados ativos e podem permanecer incorretos até outra atualização.

**Recomendação:** Invalidar ou recalcular o ranking depois do commit de remoções relevantes, preservando as proteções contra recriar contas excluídas ou bloqueadas.

**Critério de aceite:** Executar o job anterior, resetar progresso e verificar atualização posterior para os valores corretos. Cobrir também remoções de conteúdo que afetam submissões.

### R15 - [P2] Empates podem ocultar a posição pessoal fora do Top 10

**Referências:** [app/controllers/rankings_controller.rb:11](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/rankings_controller.rb#L11), [app/views/rankings/index.html.erb:32](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/views/rankings/index.html.erb#L32).

**Evidência:** Reproduzido: entre 11 estudantes empatados, o participante omitido não teve entrada nem cartão pessoal.

**Constatação:** A posição pessoal usa DENSE_RANK, a lista numera por índice e o cartão só aparece para posição maior que 10. Um excluído do limite de dez linhas pode ter posição calculada 1.

**Impacto:** O estudante não encontra sua própria classificação; as convenções de posição da lista e do cartão são inconsistentes.

**Recomendação:** Definir política única de empate e exibir o cartão com base na ausência efetiva do participante na lista principal.

**Critério de aceite:** Testar 11 ou mais empatados, empates no limite e usuários fora do Top 10. Todos devem conseguir localizar sua classificação de forma coerente.

### R16 - [P2] Inícios concorrentes disputam exclusão e criação de tentativas

**Referências:** [app/controllers/play/themes_controller.rb:6](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/play/themes_controller.rb#L6).

**Evidência:** Inspeção de concorrência; não foi executado teste simultâneo com duas conexões.

**Constatação:** start separa destroy_all e create! sem uma operação serializada. Requisições simultâneas podem disputar a restrição de tentativa ativa ou excluir a tentativa recém-criada pela outra.

**Impacto:** Duplo clique ou múltiplas abas podem produzir erro interno ou redirecionar para tentativa que já foi removida.

**Recomendação:** Serializar a operação no escopo do estudante e torná-la atômica e idempotente, definindo o comportamento de retomada ou reinício.

**Critério de aceite:** Disparar dois inícios concorrentes e confirmar uma tentativa válida, sem erro 500, perda inesperada de respostas ou destino inexistente.

### R17 - [P2] Indicadores administrativos usam contagens incompatíveis com os rótulos

**Referências:** [app/controllers/admin/dashboards_controller.rb:4](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/admin/dashboards_controller.rb#L4), [app/controllers/admin/reports_controller.rb:48](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7/app/controllers/admin/reports_controller.rb#L48).

**Evidência:** Dois cenários reproduzidos: tentativas em andamento contadas como concluídas; duas respostas exibidas como duas tentativas do tema.

**Constatação:** O dashboard calcula Temas Concluídos com ThemeAttempt.count, sem filtrar status. O CSV soma QuestionSubmission na coluna Total_Tentativas, em vez de distinguir tentativas de temas e respostas.

**Impacto:** Os indicadores podem induzir o professor a interpretar incorretamente conclusão, participação e desempenho.

**Recomendação:** Definir a unidade de cada métrica, filtrar os estados apropriados e alinhar consulta e rótulo. Distinguir respostas, tentativas iniciadas e tentativas concluídas.

**Critério de aceite:** Usar um conjunto conhecido com tentativas ativas/concluídas e múltiplas respostas; conferir os valores do dashboard e de cada coluna exportada.

## 5. Ordem sugerida para correção

### Etapa 1 - acesso administrativo e dependências (R01 a R04)

Remover o bootstrap inseguro, avaliar e corrigir os advisories, restaurar a recuperação de senha e revogar sessões antigas. Responsabilidade sugerida: manutenção de backend/infraestrutura.

### Etapa 2 - progressão pedagógica (R11 a R13)

Unificar disponibilidade por estudante, impedir conclusão incompleta e fazer a interface refletir o desbloqueio válido. Responsabilidade sugerida: manutenção do domínio do jogo.

### Etapa 3 - integridade, exportações e concorrência (R05 a R10 e R14 a R17)

Corrigir validações, retorno de operações, exportação textual, contagens e atualização do ranking. Adicionar testes com duas conexões para as operações concorrentes.

### Etapa 4 - aceite das correções (Todos os achados)

Incorporar regressões à suíte permanente, repetir lint, segurança e testes, atualizar a base de vulnerabilidades e revisar novamente os itens corrigidos. Não declarar encerrado um achado apenas por mudança no código.

## 6. Decisões e limites a manter explícitos

- O guia BUSINESS_RULES descreve a meta de 70% por tema, enquanto o PRD de gameplay a descreve por nível. A equipe deve alinhar esses documentos antes de fechar a regra de cálculo.
- A pontuação de repetição de temas já concluídos precisa de decisão explícita: o código acumula pontos de múltiplas tentativas. Este relatório não classificou esse comportamento como defeito confirmado, pois a política de repetição não está delimitada no PRD.
- Hospedagem, retenção, proteção de menores, atendimento e revisão editorial de vídeos são pendências já registradas no pacote de governança. Não foram declaradas resolvidas nem convertidas em novas falhas de código neste relatório.

## Apêndice A - Advisories de dependências

Todos os 21 registros abaixo se referem à versão instalada **8.1.3.1** dos componentes indicados. A solução informada para a linha 8.1 é **8.1.4.1 ou superior compatível**. A criticidade é a do advisory; P1/P2 são prioridades deste relatório. Conferir pré-condições de cada aviso antes de afirmar explorabilidade.

- **actionmailbox - Low - [GHSA-5957-c7qm-m469](https://github.com/rails/rails/security/advisories/GHSA-5957-c7qm-m469)**: Possible signature replay in Action Mailbox Mailgun ingress.
- **actionpack - Medium - [GHSA-2586-8ghr-69fj](https://github.com/rails/rails/security/advisories/GHSA-2586-8ghr-69fj)**: Possible restoration of destroyed sessions in Action Dispatch CacheStore.
- **actionpack - High - [GHSA-2gff-2mmg-m73p](https://github.com/rails/rails/security/advisories/GHSA-2gff-2mmg-m73p)**: Possible IP spoofing in Action Dispatch RemoteIp.
- **actionpack - Low - [GHSA-gmj8-hvj3-49mw](https://github.com/rails/rails/security/advisories/GHSA-gmj8-hvj3-49mw)**: Missing SameSite attribute on session cookies from Action Pack session stores.
- **actionpack - Medium - [GHSA-r9jg-fmfx-2gv6](https://github.com/rails/rails/security/advisories/GHSA-r9jg-fmfx-2gv6)**: Possible cache poisoning in Action Pack content negotiation.
- **actionpack - Medium - [GHSA-rwvh-fw6r-pwvp](https://github.com/rails/rails/security/advisories/GHSA-rwvh-fw6r-pwvp)**: Possible DoS vulnerability in Action Controller Live streaming.
- **actionpack - High - [GHSA-wm3x-v3qw-4jh3](https://github.com/rails/rails/security/advisories/GHSA-wm3x-v3qw-4jh3)**: Possible Strong Parameters bypass in Parameters#each_key in Action Pack.
- **actionpack - Medium - [GHSA-x6mj-8jx9-qhqv](https://github.com/rails/rails/security/advisories/GHSA-x6mj-8jx9-qhqv)**: Possible sensitive session information leak in Active Storage proxy mode.
- **actionview - Medium - [GHSA-2p2f-4rq4-gjwc](https://github.com/rails/rails/security/advisories/GHSA-2p2f-4rq4-gjwc)**: Possible XSS vulnerability in Action View text helpers.
- **actionview - Medium - [GHSA-68p9-83h6-5wpj](https://github.com/rails/rails/security/advisories/GHSA-68p9-83h6-5wpj)**: Possible XSS vulnerability in Action View tag helpers.
- **actionview - Medium - [GHSA-rq8q-p985-fjq7](https://github.com/rails/rails/security/advisories/GHSA-rq8q-p985-fjq7)**: Possible XSS vulnerability in Action View strip_tags.
- **actionview - Medium - [GHSA-v6rj-xm57-3p59](https://github.com/rails/rails/security/advisories/GHSA-v6rj-xm57-3p59)**: Possible XSS vulnerability in Action View highlight helper.
- **activestorage - Low - [GHSA-3f4q-8x5m-76v8](https://github.com/rails/rails/security/advisories/GHSA-3f4q-8x5m-76v8)**: Possible local file disclosure in Active Storage video previews and analysis.
- **activestorage - Medium - [GHSA-3w93-6hmw-whh4](https://github.com/rails/rails/security/advisories/GHSA-3w93-6hmw-whh4)**: Unsigned Content-Type in Active Storage GCS direct uploads with cache_control.
- **activestorage - Medium - [GHSA-4v2w-w6g6-f8f8](https://github.com/rails/rails/security/advisories/GHSA-4v2w-w6g6-f8f8)**: Possible DoS vulnerability in Active Storage proxy mode via storage errors during streaming.
- **activestorage - Critical - [GHSA-f3w6-w445-fwh9](https://github.com/rails/rails/security/advisories/GHSA-f3w6-w445-fwh9)**: Possible arbitrary file write and read in Active Storage image analysis.
- **activestorage - Medium - [GHSA-hfr4-8rjc-97m2](https://github.com/rails/rails/security/advisories/GHSA-hfr4-8rjc-97m2)**: Possible circumvention of file size limits in Active Storage direct uploads to Google Cloud Storage.
- **activestorage - Medium - [GHSA-p2pm-g2h6-7j5j](https://github.com/rails/rails/security/advisories/GHSA-p2pm-g2h6-7j5j)**: Possible DoS vulnerability in Active Storage filename handling.
- **activestorage - High - [GHSA-v924-7rp8-4mxh](https://github.com/rails/rails/security/advisories/GHSA-v924-7rp8-4mxh)**: Possible arbitrary file read and remote code execution in Active Storage video previews, analysis and image processing.
- **activesupport - Medium - [GHSA-2w9f-fxwj-w2qf](https://github.com/rails/rails/security/advisories/GHSA-2w9f-fxwj-w2qf)**: Possible XSS vulnerability in Active Support MessagePack serializer.
- **activesupport - High - [GHSA-8474-xrp6-wh69](https://github.com/rails/rails/security/advisories/GHSA-8474-xrp6-wh69)**: Possible DoS vulnerability in Active Support safe_constantize.

## Apêndice B - Fontes e rastreabilidade

- Snapshot do código: [10741c9](https://github.com/arthun01/GameQTA/blob/10741c9b54fd47c402d89b88f45170fb55cff7a7).
- Diretrizes: `AGENTS.md`, `.opencode/rules/` e `docs/DEVELOPMENT_GUIDE.md`.
- Requisitos: `ai-sdd/prd-gameplay-estudante/prd.md`, `ai-sdd/prd-gamificacao-ranking/prd.md`, pacote de governança, mapas e guias do projeto.
- [OWASP - CSV Injection](https://community.owasp.org/attacks/CSV_Injection).
- [Rails - aviso RemoteIp](https://github.com/rails/rails/security/advisories/GHSA-2gff-2mmg-m73p).
- [Rails - aviso Strong Parameters](https://github.com/rails/rails/security/advisories/GHSA-wm3x-v3qw-4jh3).

Evidências locais da sessão de revisão (arquivos temporários, sujeitos a limpeza):

```text
/tmp/gameqta-review-rubocop.log
/tmp/gameqta-review-brakeman.log
/tmp/gameqta-review-tests.log
/tmp/gameqta-review-system.log
/tmp/gameqta-review-reproductions.log
/tmp/gameqta_complete_review_test.rb
/tmp/gameqta-review-fresh-audit.log
/tmp/gameqta-review-importmap.log
```

Nenhum achado deste relatório foi corrigido durante a revisão. A criação deste documento não altera o funcionamento da aplicação.
