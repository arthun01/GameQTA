# Avaliação preliminar dos tratamentos e entrada direta

Data: 03/11/2026. Responsável informado: Guilhardes de Jesus Júnior, guilhardesj@gmail.com.

## Decisão de produto e limite da avaliação

Manter o cadastro público existente e os campos de idade, cidade e escolaridade, com a mesma experiência para todas as idades aceitas. Cidade e escolaridade permanecem opcionais; não foram removidos dados. Não criar aprovação externa, cadastro de responsáveis ou upload de documentos como barreira geral.

Esta é uma avaliação preliminar para apoiar decisão do controlador. Não é parecer jurídico, relatório de impacto aprovado ou conclusão de que todo o tratamento de menores pode ocorrer sem consentimento. A hipótese de legítimo interesse precisa de análise por finalidade e prevalência do melhor interesse. Uma avaliação inconclusiva não é aprovação. Aprovação de requisitos de produto não substitui essa avaliação.

## Inventário e teste preliminar por finalidade

| Finalidade / dados | Benefício concreto | Necessidade e alternativas | Riscos e proteções | Resultado / ação |
|---|---|---|---|---|
| Conta: e-mail, nome, hash de senha | Identificar acesso e permitir progresso persistente | Hash necessário para a autenticação atual; avaliar se nome completo e e-mail são indispensáveis ou podem futuramente ser reduzidos | Identificação e acesso indevido; hash BCrypt, sessão assinada, perfil protegido por senha, rate limit existente e exclusão pelo titular | Legítimo interesse é hipótese em análise para operação; necessidade da identificação completa ainda exige validação. Não declarado aprovado |
| Progresso: tentativas, alternativas, acertos, pontuação e tempo | Retomar jornada e apresentar resultado pedagógico | Necessários à mecânica atual; não coletar comportamento de navegação comercial | Inferências de desempenho; acesso da própria conta e administração autenticada, remoção em cascata | Candidato a legítimo interesse para serviço educativo, sujeito à revisão de retenção, riscos de menores e acesso |
| Ranking: código, pontuação e tempo | Classificação e participação no jogo | Código substitui a exposição do nome; não acrescenta formulário | Relação indireta com pessoa; código aleatório, sem nome/e-mail no ranking. Continua pseudonimizado, não anônimo | Exposição reduzida; avaliar necessidade da classificação compartilhada e seu impacto antes de concluir a base legal |
| Segurança: IP, navegador e dados de sessão | Identificar sessões e manter autenticação | Campos já registrados no login; duração deve ser justificada, sem publicidade | Dispositivo compartilhado e rastreabilidade; cookies HttpOnly/SameSite existentes, logs filtram senha/e-mail, no-store em páginas estudantis e relatórios | Retenção, hospedagem, TLS e características dos cookies ainda exigem avaliação da etapa específica |
| Idade | Campo existente solicitado pelo projeto | Não presumir necessidade da idade exata: validar a finalidade atual e eventual suficiência de faixa etária | Erro de autodeclaração e discriminação; dado restrito à conta/admin, sem liberação automática para pesquisa | Necessidade e base ainda inconclusivas; conservar campo conforme escopo sem tratar sua presença como verificação etária |
| Cidade e escolaridade | Dados já acessíveis à administração em relatórios; possíveis recortes futuros indicados pelo professor | São opcionais e removíveis no perfil; possível pesquisa futura isoladamente não justifica coleta/guarda | Reidentificação em turmas pequenas e exportações; não aparecem no ranking e acesso exige administração | Uso científico não autorizado por esta entrega; confirmar finalidade atual, necessidade, prazo e base com o responsável |
| Pesquisa futura | Possibilidade relatada, sem estudo/análises definidos | Não habilitar novo uso com base no aceite do jogo. Instituição e estudo terão avaliação própria | Desvio de finalidade e identificação por cruzamento | Não aprovado. Definir estudo/banco, papéis, base, ética e condições antes da utilização científica |

## Melhor interesse e expectativas

O benefício pretendido é acesso à aprendizagem sem custo ou demora por etapas administrativas. A aplicação não precisa de chat, publicidade comportamental, compras ou contatos entre desconhecidos para cumprir esse objetivo. As salvaguardas da entrega são comuns a todos e reduzem exposição, mas não demonstram sozinhas conformidade com o ECA Digital. Avaliar conteúdo/vídeos, tempo, classificação indicativa, supervisão e canal de notificações nas etapas próprias.

As expectativas de um aluno não abrangem automaticamente uso científico identificável ou divulgação do desempenho para terceiros. Um código de jogador protege a apresentação, mas o controlador ainda detém a chave de associação. Mesmo tabelas agregadas podem permitir identificação em grupos pequenos.

## Conclusão preliminar

É possível construir a experiência técnica de cadastro direto com salvaguardas, sem afirmar que a base de todos os tratamentos foi validada. A decisão final sobre legítimo interesse depende do controlador, preferencialmente com assessoria jurídica, incluindo análise específica das crianças e adolescentes. Se não houver fundamento adequado para alguma finalidade, deverá cessar/reduzir esse tratamento ou obter o consentimento pertinente; não trocar a base apenas para dispensar uma autorização.

Permanecem indispensáveis à liberação definitiva: decidir necessidade e base por finalidade, hospedagem e operadores, retenções, procedimentos de supervisão/proteção e operação efetiva do atendimento. A UESC não foi indicada como operadora formal do jogo; eventual pesquisa institucional não muda retroativamente os papéis da aplicação.

## Referências

- LGPD, arts. 6º, 7º, 8º, 10, 14, 18 e 46: https://www2.camara.leg.br/legin/fed/lei/2018/lei-13709-14-agosto-2018-787077-normaatualizada-pl.html
- Enunciado CD/ANPD 1/2023: https://bibliotecadigital.mj.gov.br/bitstream/1/10215/2/Enunciado_ANPD_2023_1.html
- Guia ANPD de legítimo interesse (finalidade, necessidade, ponderação e salvaguardas): https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_legitimo_interesse.pdf/@@display-file/file
- ECA Digital e orientações: https://www.gov.br/anpd/pt-br/assuntos/eca-digital
- Guia ANPD de fins acadêmicos/pesquisa: https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/web-guia-anpd-tratamento-de-dados-para-fins-academicos.pdf
