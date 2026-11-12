# Correções do code review - Game QTA

Data: 04/11/2026. Branch: `rafael`. Referência: [relatório original](2026-11-04-code-review.md), que analisou o commit `10741c9`.

Os 17 achados receberam correções de código e verificação. O relatório original e seu PDF permanecem como registro histórico da revisão; este documento registra o estado posterior. As alterações de governança, idade opcional e documentos 1.0 anteriores a esta rodada foram preservadas. Não houve merge nem implantação em produção.

## Correções e evidências

| ID | Correção | Verificação |
|---|---|---|
| R01 | Preparação normal do banco não carrega demonstração. Seeds de demonstração exigem desenvolvimento e `LOAD_DEMO_DATA=1`, inclusive se o arquivo for chamado diretamente. Primeiro administrador é provisionado por tarefa explícita com credenciais externas, sem imprimir senha. | `SeedSafetyTest`, `AdminBootstrapTest`; nenhuma carga de demonstração foi executada no banco real durante as correções. |
| R02 | Rails e componentes atualizados para 8.1.4.1; mínimo corrigido no Gemfile. Nenhum advisory foi ignorado. | `bin/bundler-audit check --update`: aprovado, base `516ea4757d5eec778c49af8371c23309c4b70f42`, 1.351 advisories. |
| R03 | Ambos os formatos do e-mail usam a rota administrativa com token válido. Assunto, mensagens e formulários localizados. Host, remetente e SMTP de produção recebem configuração externa. | `CodeReviewSecurityTest`: job de entrega executado no adaptador de teste, HTML/texto renderizados e destinatário/URL conferidos. Nenhuma mensagem externa enviada. |
| R04 | Mudança efetiva do digest revoga todas as sessões administrativas dentro da transação, tanto em recuperação quanto em gestão. Edição apenas de e-mail preserva sessões. | Testes de reset com múltiplas sessões, cookie antigo recusado, token anterior invalidado e troca pela gestão. |
| R05 | Serializador CSV neutraliza prefixos de fórmula, controles, espaços, caracteres de formatação e equivalentes Unicode; aplica aspas CSV sem alterar os dados armazenados. Proteção também cobre nomes de temas e níveis. | Onze entradas na regressão de exportação; nove entradas importadas no LibreOffice Calc e convertidas para XLSX sem elementos de fórmula. |
| R06 | Contexto de recuperação exige senha e confirmação presentes; atualização inválida retorna formulário com erros e status 422. | Casos de parâmetros ausentes, vazios, confirmação ausente e divergente, com digest preservado; reset real aceita e invalida token. |
| R07 | E-mail administrativo tem presença, formato, tamanho e unicidade. Gravação pela gestão usa savepoint e transforma conflito do índice único em erro de formulário. | Criação/edição inválidas por HTTP e duas conexões sincronizadas antes do INSERT concorrente. |
| R08 | Recuperação limitada por origem e destinatário normalizado; chave de destinatário usa hash. Resposta pública permanece indistinguível para conta existente, inexistente e requisição limitada. | `CodeReviewRateLimitTest`, com armazenamento real em memória, mudança de IP/destinatário, excesso e expiração da janela. Produção mantém o cache compartilhado configurado. |
| R09 | Exclusões usam lock transacional compartilhado no PostgreSQL; verificação de ator, autoexclusão e último administrador ficam no model. Callback protege também `destroy` direto. | `CodeReviewConcurrencyTest`: exclusões cruzadas com duas conexões deixam um administrador. `AdminTest`: recusa de exclusão do último preserva suas sessões. |
| R10 | Exclusão de nível verifica o retorno do model e informa a restrição, sem sucesso fictício. | Requisições para nível vazio e nível com dependências. |
| R11 | Disponibilidade por estudante é aplicada ao início, às operações sobre tentativas e à conclusão; conta bloqueada não inicia ou conclui. | POST direto para nível bloqueado recusado, seguido de acesso permitido após pré-requisitos válidos. |
| R12 | Jornada usa o mesmo critério de disponibilidade do domínio para exibir níveis liberados. | Conclusão dos temas do primeiro nível libera o próximo na página e no servidor. |
| R13 | Conclusão exige todas as questões encerradas e todos os temas para avaliar o nível. Denominador contém todas as questões exigidas. Transição ocorre em POST; GET somente exibe resultado. Aprovação compara a proporção exata, sem liberar por arredondamento. | Questões omitidas/reveladas sem resposta, temas incompletos, GET sem mutação, aprovação válida, reprovação com reset e repetição idempotente da conclusão. |
| R14 | Remoções de respostas enfileiram atualização após commit, guardando o ID do estudante antes de destruir associações. | Ranking recalculado após reset e job após exclusão direta; suítes existentes preservam proteção contra recriar ranking de conta excluída ou bloqueada. |
| R15 | Pódio, lista e cartão utilizam DENSE_RANK. Corte de dez linhas é estável por ID; cartão depende da ausência real na lista, não de posição maior que dez. | Onze participantes empatados, com cartão pessoal em posição 1 para quem ficou fora do corte; testes existentes de ranking. |
| R16 | Início serializado por estudante retoma a tentativa ativa em vez de excluir respostas. | Repetição por HTTP conserva ID e respostas; duas conexões retornam a mesma tentativa, sem exceção ou perda. |
| R17 | Dashboard conta somente tentativas concluídas. CSV distingue tentativas de tema de respostas encerradas; taxa usa respostas encerradas, incluindo timeout, e exclui apenas revelações pendentes. | Conjunto conhecido com uma tentativa e duas respostas, conferindo dashboard e colunas do CSV. |

Também foi coberto conteúdo vazio: iniciar tema sem questões é recusado, e uma tentativa cujo conteúdo foi retirado retorna à jornada sem entrar em ciclo de conclusão automática.

## Decisões de implementação

- A aprovação de 70% é por nível, conforme RF-008 a RF-010 do PRD de gameplay. O guia BUSINESS_RULES foi alinhado; todos os temas e questões exigidos precisam ser concluídos.
- O cálculo continua usando a tentativa mais recente de cada tema para o progresso. O acúmulo histórico de pontos em repetições não foi redefinido nesta rodada, pois o relatório não o classificou como defeito confirmado.
- A apresentação usa posições compartilhadas em empates de pontuação e tempo. O ID estabiliza apenas quais dez linhas aparecem; não desfaz o empate de posição.
- Os novos recursos REST de início/conclusão preservam os caminhos públicos de início e resultado. O avanço automático usa um controlador Stimulus genérico e possui botão de conclusão para navegação sem JavaScript.
- Fixtures possuem ordem explícita dos níveis e conteúdo válido no nível seguinte, para verificar progressão real. Dados de desenvolvimento não foram reordenados nem receberam aprovações artificiais.

## Validação

| Verificação | Resultado |
|---|---|
| RuboCop | 149 arquivos, nenhuma infração |
| Brakeman | Zero alertas e erros |
| Bundler-audit com base atualizada | Nenhuma vulnerabilidade conhecida |
| Testes da aplicação | 132 testes, 910 assertions, zero falhas/erros/skips |
| Testes de navegador | 31 testes, 203 assertions, zero falhas/erros/skips |
| Concorrência | Duas conexões reais para exclusões, início de tentativa e conflito de e-mail |
| Importmap audit | Nenhum pacote vulnerável encontrado |
| CSV no LibreOffice Calc | Nove entradas de teste, nenhum elemento de fórmula no XLSX convertido |

As reproduções iniciais de segurança e jogo falharam antes das correções; os cenários de regressão foram incorporados à suíte. Concorrência foi exercitada no domínio chamado pelos controllers, usando conexões distintas ao PostgreSQL. O teste não é uma simulação de produção nem teste de carga.

Logs locais: `/tmp/gameqta-fixes-*.log`. Testes de navegador e da aplicação foram confirmados separadamente na validação final. A conferência de CSV não garante que outro programa, configuração de importação ou transformação posterior preserve a neutralização; Microsoft Excel não foi executado neste ambiente.

## Operação e limites

- Publicação continua exigindo configuração real de HTTPS/proxy, domínio, remetente e entrega de e-mail. A alteração oferece configuração por ambiente; não contrata nem configura uma conta externa automaticamente.
- Instalações antigas que carregaram as credenciais de demonstração devem substituí-las e revogar as sessões correspondentes antes de exposição pública. Nenhuma senha de conta real foi trocada nesta rodada.
- CSV de temas ganhou `Total_Respostas`; consumidores do formato anterior devem usar os cabeçalhos atualizados. Dados armazenados dos estudantes não são alterados pela neutralização do arquivo.
- Rotinas de retenção e avisos aprovadas no pacote de governança continuam como trabalho operacional separado. Esta correção não afirma que foram automatizadas.
- Sem merge, deploy ou certificação jurídica. O PDF de governança 1.0 foi preservado.

Fontes técnicas: [release oficial Rails 8.1.4.1](https://rubyonrails.org/2026/11/4/Rails-8.0.5.2-and-8.1.4.1-have-been-released), [Rails rate limiting](https://api.rubyonrails.org/classes/ActionController/RateLimiting/ClassMethods.html), [OWASP CSV Injection](https://community.owasp.org/attacks/CSV_Injection).
