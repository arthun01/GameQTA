# Design — governanca-juridica-lgpd-acessibilidade

**Status:** Design do Paper adiado por orientação expressa do usuário.
**Ferramenta principal:** Implementação Rails com a identidade visual existente.

O usuário autorizou implementar o tópico 1 sem criar artboards; o colaborador responsável pelo Paper poderá acrescentar o design posteriormente. A funcionalidade tem UI e não está classificada como N/A. Nenhuma configuração adicional do Paper é necessária para esta entrega.

## Telas

| # | Tela | RF cobertos | Breakpoint | Origem | Referência |
|---|------|-------------|-----------|--------|-----------|
| 1 | Termos de Uso | RF-001 a RF-003, RF-007, RF-008 | mobile, desktop, impressão | Código | `app/views/terms/show.html.erb` |
| 2 | Política de Privacidade | RF-001, RF-002, RF-004 a RF-008 | mobile, desktop, impressão | Código | `app/views/privacy_policies/show.html.erb` |
| 3 | Acesso aos documentos | RF-001 | mobile, desktop | Código | `app/views/shared/_legal_links.html.erb` |

## Descrições

Páginas públicas com logo, navegação entre documentos, indicação de minuta, título, versão, data, resumo, índice de seções e texto integral em coluna de leitura. Cores Emerald e Slate existentes; foco visível e títulos semânticos. Os links nos layouts existentes abrem em nova aba para preservar formulários e a partida em andamento.

A impressão usa a mesma página: o navegador oculta navegação e instruções, mantém versão, data e indicação de minuta e permite quebra natural do texto entre folhas.

## Notas para a Tech Spec

Priorizar HTML semântico e CSS, sem acrescentar dependência JavaScript à leitura ou impressão. Os textos jurídicos e a implementação funcional poderão receber acabamento visual posterior sem alterar seus requisitos.

## Notas para Implementação

Este registro documenta a decisão de adiar o Paper; não representa aprovação de artboards ou auditoria integral de acessibilidade. O tópico 2 está detalhado abaixo; os tópicos 3 e 4 serão tratados em suas próprias rodadas.


## Telas do tópico 2

Mantida a autorização de implementar sem Paper, seguindo a identidade existente. O planejamento de autorização dos responsáveis está em definição com o usuário.

| # | Tela | RF cobertos | Breakpoint | Origem | Referência |
|---|------|-------------|-----------|--------|-----------|
| 4 | Cadastro e aceite | RF-009 a RF-011 | mobile, desktop | Texto | Checkbox desmarcado, links em nova aba, aviso de minuta, campos opcionais identificados |
| 5 | Atualização dos documentos | RF-007, RF-012 | mobile, desktop | Texto | Documentos e versões, aceite explícito; links para perfil e exclusão preservados |
| 6 | Meu perfil e meus dados | RF-015 a RF-017 | mobile, desktop | Código | `app/views/users/profiles/show.html.erb` |
| 7 | Editar meus dados | RF-009, RF-015 | mobile, desktop | Código | `app/views/users/profiles/edit.html.erb` |

Perfil: seção de dados com rótulos e valores, ação de editar e seção separada de exclusão com consequências, senha e confirmação. Edição: campos de cadastro, indicação dos opcionais e confirmação com senha. Erros em bloco acessível; sem modais dependentes de JavaScript ou mensagens de atendimento inexistente.

A proposta de faixas etárias não foi aprovada; nenhuma tela de autorização de responsáveis é declarada implementada.

## Atualização da opção 1 — 03/11/2026

Mantém telas e fluxo do cadastro, com os campos atuais. Ranking troca nome por código automático; perfil mostra o próprio código. Cadastro, perfil e documentos recebem contato público de privacidade, em texto legível e link de e-mail, sem modais ou nova aprovação. A tarefa 7.0 não depende do Paper.


## Telas dos tópicos 3 e 4 — Texto/Código

8. Rodapé: aviso de cookies próprios e link à política, no fluxo da página, sem cobrir o jogo.
9. Vídeo: card com explicação de dados compartilhados e dois botões equivalentes (carregar este vídeo / continuar sem vídeo); após carregar, botão para desativar. Sem escolha persistente.
10. Questão: ajuste de tempo antes da revelação (1 a 10×), relógio nomeado com anúncios pontuais, título e alternativas em fieldset, confirmação explícita. Sem pergunta sobre deficiência ou idade adicional.
11. Jornada/admin: mesmos componentes e identidade; foco visível, skip link, dialog com título único e fechamento nomeado, formulários com rótulos e erros associados. Navegação administrativa reorganiza verticalmente no celular.

Sem dependência de Paper, conforme autorização vigente. Conteúdo de vídeos não é substituído por transcrições inventadas; revisão editorial é registrada na auditoria.

## Atualização documental 1.0 - 04/11/2026

Termos e política completos, com número e data; aviso de minuta fica ausente quando não há aviso configurado. O formulário de aceite conserva sua distinção de consentimento e dispensa o aviso de minuta na versão 1.0. Idade passa a ser opcional no cadastro e perfil, com orientação comum sobre finalidade, opção de omitir e remoção. Identidade visual do aplicativo preservada; PDF serifado, monocromático e com margens de 25 mm. Paper continua dispensado conforme autorização.
