# Comparação e consolidação — rafael e arthur-testes

Data: 10/11/2026. Objetivo: concentrar a revisão e a integração em um PR para `main`, preservando as contribuições úteis das duas branches.

## Referências comparadas

- Base comum: `1172fd22a467862968da8740c2f6246bee0d69f2` — merge do PR #22, já em `main`.
- `rafael`: `c51fc22c70b0c6cd6e4d1116a4df4b96fc68b74f` — PR #23 aberto, governança 1.0 e correções da primeira revisão.
- `arthur-testes`: `52f79c94bafda5a51ae58c12fd9814bf17d6d1a1` — correções de progressão, pontuação e interface.

As duas branches tinham um commit próprio desde a base comum. Portanto, o trabalho do Arthur não continha a entrega do PR #23, e a versão de Rafael não continha os ajustes exclusivos do Arthur. Ausências decorrentes desse desenvolvimento paralelo não são classificadas automaticamente como regressões introduzidas pelo colega.

## Diferenças relevantes e decisões

| Área | rafael | arthur-testes | Consolidação |
|---|---|---|---|
| Governança | Documentos 1.0, manual/PDF completo e idade opcional | Estado anterior ao PR #23 | Preserva integralmente a entrega de Rafael |
| Dependências e administração | Rails 8.1.4.1, proteção de seeds, recuperação, revogação, limites e concorrência | Validações e traduções parciais | Mantém as proteções de Rafael e as traduções de login de Arthur |
| Início de tema | Retoma tentativa ativa com trava | Apaga tentativa em andamento antes de iniciar outra | Mantém retomada e preservação de respostas |
| Conclusão | POST transacional; GET somente leitura; validações nas questões | Conclusão/reset por GET, com algumas verificações | Mantém recursos REST e verificações de Rafael |
| Aprovação | Comparação inteira do mínimo de 70% | Comparação da nota arredondada | Mantém proporção exata |
| Repetição de tema aprovado | A tentativa nova em andamento podia bloquear níveis seguintes | Preserva conclusão anterior | Preserva conclusão até efetivar a nova; reprovação nova aplica reset |
| Consulta de progresso | Instanciava todo o histórico antes de escolher por tema | Consultas por tema com limite | Seleção no banco de uma tentativa por tema, concluída mais recente ou tentativa atual quando não houver conclusão |
| Pontos | Ranking calculado, sem gravar pontos da resposta nem sincronizar total da conta | Grava `score` e atualiza `users.total_score` | Incorpora as duas correções de Arthur |
| CSV e métricas | Proteção abrangente, unidades separadas e empates coerentes | Sanitização e métricas parciais | Preserva implementação de Rafael |
| Imagens ODS | Baseadas no ID do banco | Baseadas na posição pedagógica | Incorpora Arthur, evitando consulta repetida por imagem |
| Avatar e perfil | Inicial fixa nas duas telas | Inicial real, link acessível e saída do Turbo Frame | Incorpora Arthur |
| Estados da jornada | Disponibilidade correta, sem os novos indicadores | Indicadores de níveis e temas concluídos | Incorpora indicadores e exibe percentual aprovado |
| Identidade visual | Alguns botões azuis e metadados antigos | Emerald, nome Game QTA e placeholders traduzidos | Incorpora Arthur |
| Higiene e testes | Scripts/controllers órfãos ainda presentes; interações reais | Remove órfãos; alguns testes usam cliques JavaScript | Remove órfãos, preserva cliques reais e adiciona verificações úteis |

As principais correções de design mencionadas pelo colega são as imagens ODS, avatar/perfil, indicadores de conclusão e padronização Emerald. O layout e a identidade existentes foram preservados.

## Quatro pendências da segunda revisão

1. **Histórico:** `ThemeAttempt.latest_for` usa `DISTINCT ON` e retorna no máximo uma tentativa por tema. Uma regressão com 500 tentativas históricas verifica o limite de objetos instanciados.
2. **Cadastro simultâneo:** `User#save_for_registration` trata somente conflito do índice único de e-mail dentro de savepoint. Duas requisições concorrentes produzem sucesso e formulário 422, com uma conta, um aceite e uma sessão.
3. **Desbloqueio:** `User#unblock!` recompõe a classificação a partir das respostas preservadas, na operação com trava da conta.
4. **Login:** destinos administrativos e estudantis usam chaves distintas, caminhos relativos e validação da área. Há regressões para os dois sentidos e para a preservação simultânea dos destinos.

Os relatórios anteriores continuam como registro histórico. A correção destes quatro itens pertence a esta consolidação.

## Revisão em dois eixos

**Standards:** preservar as proteções de Rafael e incorporar os ajustes de Arthur sem duplicar recálculo de ranking, carregar histórico ilimitado ou executar consulta de imagens para cada card. A leitura final não confirmou nova regressão nos pontos de integração examinados.

**Spec:** preservar os requisitos de interface e pontuação de Arthur, adaptando-os às APIs seguras de Rafael. O PRD, design, techspec e tarefas importados foram alinhados à conclusão por POST, comparação exata e comportamento de repetição. A leitura final não confirmou novo defeito bloqueante nesses fluxos; houve correção da descrição de reprovação para não depender da nota arredondada.

## Evidências e limites

Antes das correções, oito regressões novas falharam, confirmando mistura de destinos, ausência de recomposição do ranking, histórico ilimitado, pontuação não persistida, falta de avatar e comportamento incorreto ao repetir tema aprovado. As verificações finais estão registradas abaixo após execução.

| Verificação local em 10/11/2026 | Resultado |
|---|---|
| RuboCop com autocorreção | 150 arquivos, nenhuma infração |
| Brakeman | Zero erros e alertas |
| Bundler-audit com base atualizada | Nenhuma vulnerabilidade conhecida; base `38f94284b05c2052b13a4922a86cc7cffb2266e2` |
| Importmap audit | Nenhum pacote vulnerável conhecido |
| Suíte da aplicação | 147 testes, 998 assertions, zero falhas/erros/skips |
| Suíte de navegador | 32 testes, 227 assertions, zero falhas/erros/skips |
| Jornada e perfil no navegador | Aprovação/desbloqueio, tela de 390px sem transbordamento horizontal e avatar saindo do Turbo Frame |
| Governança e dependências | Textos jurídicos, PDF, Gemfile/lock e banco sem alterações em relação ao estado original de `rafael` |

As capturas locais da jornada em computador e celular foram inspecionadas visualmente. Evidências temporárias: `/tmp/gameqta-consolidation-*.log` e `/tmp/gameqta-consolidation-journey-*.png`; o ambiente pode removê-las. A revisão não substitui homologação humana, teste de carga, auditoria jurídica ou verificação da implantação. Os resultados acima são locais; o estado do CI remoto deve ser consultado no PR.

Além das regressões existentes, foram acrescentadas verificações de pontuação por dificuldade, erro/timeout, 1.399 acertos em 2.000 questões, repetição concluída com reprovação/reset, cadastro simultâneo real e navegação da jornada após aprovação. As suítes de aplicação e navegador são executadas separadamente no banco de testes; não enviam e-mails reais nem modificam contas de uso real.

Esta entrega não configura a hospedagem, o SMTP ou os jobs de produção e não automatiza as rotinas de retenção da política. A classificação após reset continua dependendo dos jobs. Pontos históricos não são regravados em massa: novas respostas passam a guardar `score`, e o total agregado mantém o cálculo existente pelas respostas e dificuldades atuais. Não houve nova migração nesta consolidação; o PR completo ainda exige a migração anterior de idade opcional.

## Publicação

O histórico de `arthur-testes` é incorporado à branch `rafael`, com resolução explícita dos conflitos, preservando a autoria das duas linhas de trabalho. O PR #23 é atualizado para representar a versão consolidada; o PR #22 já está integrado. Merge em `main` e implantação continuam como ações posteriores à revisão.
