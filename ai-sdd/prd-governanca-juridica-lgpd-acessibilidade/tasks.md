# Tarefas de Implementação - Governança Jurídica, LGPD e Acessibilidade

## Referências

- **PRD:** [prd.md](prd.md)
- **Tech Spec:** [techspec.md](techspec.md)
- **Design:** [design.md](design.md) — Paper adiado por orientação do usuário.

## Resumo

A primeira rodada implementou o tópico 1; a rodada do tópico 2 está registrada abaixo. O usuário autorizou seguir diretamente com as páginas; a especificação e as tarefas preservam a rastreabilidade AI-SDD. Os tópicos seguintes serão detalhados individualmente antes de sua implementação.

- **Total de tarefas desta rodada:** 2.
- **Requisitos cobertos:** RF-001 a RF-006, RF-008 e parte documental de RF-007.
- **Pendência de RF-006:** canal real de atendimento e operação das solicitações.
- **Pendência de RF-007:** comunicação de mudanças e associação de versões a aceites, no tópico 2.

## Tarefas

| # | Tarefa | Arquivo | Deps | Status |
|---|--------|---------|------|--------|
| 1.0 | Documentos públicos e minutas localizadas | [tasks/1_task.md](tasks/1_task.md) | — | ✅ |
| 2.0 | Navegação, impressão e documentação | [tasks/2_task.md](tasks/2_task.md) | 1.0 | ✅ |

**Legenda:** ⬜ Pendente · 🔄 Em andamento · ✅ Implementação validada. A validação jurídica e o atendimento não são inferidos pelo status técnico.

## Ordem de Execução

`1.0 → 2.0 → detalhamento do tópico 2 → tópico 3 → tópico 4 → revisão final → PR para main`

O tópico 1 permanecerá com pendências jurídicas e operacionais explícitas. Os demais tópicos e a feature completa não serão marcados como concluídos nesta rodada.

## Validação da rodada — 27/10/2026

- `bin/rails test`: **76 testes, 338 assertions, nenhuma falha ou erro**. Inclui os 7 testes novos de integração.
- `bin/rails test test/system/legal_documents_test.rb`: **2 testes, 20 assertions, nenhuma falha ou erro**. Confere nova aba, navegação por seção, viewport móvel e mídia de impressão.
- `bin/rails test:system`: **23 testes, 80 assertions, 2 falhas e 7 erros**. As duas falhas e seis erros reproduzem o resultado anterior (`tmp/setup/system-tests.log`): alternativas dinâmicas, texto "Iniciar Tema", seletores `.group` e confirmação de exclusão de tema. O erro adicional foi do Chromium ao localizar um nó durante exclusão de administrador; o teste passou isoladamente, sem mudanças, com **1 teste e 3 assertions**. A suíte completa de navegador continua reprovada; os testes novos passaram nas duas execuções.
- Conferência visual no navegador em 1366 × 900 e 390 × 844; ambas as páginas funcionam sem Paper. CSS compilado com `bin/rails tailwindcss:build`.
- `bin/rubocop -a`: **120 arquivos, nenhuma infração**, com cache em `/tmp` para respeitar as permissões locais.
- `bin/brakeman --no-pager`: interrompido pela exigência de versão atual (8.0.6 instalada, 8.1.0 disponível). A análise adicional com `bundle exec brakeman --no-pager` executou 79 verificações e encontrou **zero alertas e zero erros**; isso não torna o comando obrigatório aprovado.
- `bin/bundler-audit`: **8 avisos preexistentes**, um em `crass` 1.0.7 e sete em `net-ssh` 7.3.3. As dependências não foram modificadas nesta entrega.

RF-006 continua parcial até existir atendimento funcional. RF-007 continua parcial até a implementação dos aceites e da comunicação de alterações. O status técnico das tarefas não significa que os documentos estejam prontos para adoção definitiva.


## Rodada do tópico 2 — em andamento

O usuário confirmou que disponibilizará e-mail futuramente e autorizou prosseguir. A autorização dos responsáveis será definida agora, conforme sua resposta; o esclarecimento operacional está pendente.

| # | Tarefa | Arquivo | Deps | Status |
|---|--------|---------|------|--------|
| 3.0 | Aceite versionado e contas existentes | [tasks/3_task.md](tasks/3_task.md) | 1.0 | ✅ |
| 4.0 | Minimização e edição segura do perfil | [tasks/4_task.md](tasks/4_task.md) | 2.0 | ✅ |
| 5.0 | Exclusão segura e jobs pendentes | [tasks/5_task.md](tasks/5_task.md) | 4.0 | ✅ |
| 6.0 | Autorização de responsáveis e exposição de menores | [tasks/6_task.md](tasks/6_task.md) | Definição com o usuário | ⬜ |

O canal de atendimento e as retenções não serão declarados resolvidos. A alteração do escopo de menores será incorporada à especificação antes da implementação dessa parte.


**Definição de menores:** após escolher inicialmente verificação presencial/escola, o usuário questionou a autorização geral para todos os menores e pediu preservar cadastro aberto. As faixas não foram aprovadas. A tarefa 6.0 continua pendente; não foi implementado bloqueio etário novo ou suposta autorização automática. O aceite de documentos não resolve RF-013, RF-014 ou RF-018.


## Validação da entrega parcial do tópico 2 — 27/10/2026

- `bin/rails test`: **93 testes, 533 assertions, zero falhas e zero erros**. O cadastro com aceite e revisão, os registros preservados após atualização dos textos, a correção de dados, exclusão e isolamento das demais contas estão cobertos.
- Testes de navegador da entrega (`legal_documents`, `legal_acceptance`, `student_profile` e `user_registration`): **5 testes, 35 assertions, zero falhas e zero erros**. Fluxos de cadastro, aceite de conta antiga com leitura em nova aba, edição e exclusão foram validados com contas de teste.
- `bin/rails test:system`: **25 testes, 92 assertions, 2 falhas e 8 erros**. As duas falhas e seis erros dos fluxos antigos continuam (texto Iniciar Tema, seletores .group, alternativas dinâmicas e modal de tema). Ocorreram também dois erros adicionais do Chromium, Node with given id does not belong to the document, em testes administrativos de criação e exclusão. A instabilidade do navegador já foi observada na rodada anterior, mas não se declara aprovação da suíte completa. Os testes da entrega passaram também nessa execução.
- `bin/rubocop -a`: **131 arquivos, nenhuma infração**, cache em /tmp.
- `bin/brakeman --no-pager`: continua interrompido pela versão instalada 8.0.6 versus 8.1.0 disponível. Análise adicional com `bundle exec brakeman --no-pager`: **79 verificações, zero alertas e zero erros**.
- `bin/bundler-audit`: permanecem os **8 avisos anteriores**, em crass 1.0.7 e net-ssh 7.3.3; dependências não alteradas.
- As duas migrações foram aplicadas no banco local com `bin/rails db:migrate`; schema atualizado automaticamente. Nenhuma conta de desenvolvimento foi excluída nem recebeu aceite retroativo. As fixtures de aceites são apenas exemplos para o banco de testes.
- Conferência visual de cadastro e perfil no navegador; o perfil mantém o conteúdo dentro da largura de 390 px. CSS compilado. Servidor de desenvolvimento continua ativo.

**Escopo pendente:** RF-013, RF-014 e RF-018 (autorização, faixas, avaliação de menores e exposição), parte de RF-015/RF-006 (atendimento público, representantes e contas sem acesso), RF-017 (retenções e cópias fora da aplicação ativa), identidade formal e bases legais. RF-007 ganhou comunicação por tela de atualização, revisão, versão e cópia por aceite. A entrega do tópico 2 é parcial; a tarefa 6.0 e o pacote completo não foram marcados como concluídos. Tópicos 3 e 4 e revisão final antes do PR permanecem pendentes.


## Atualização do planejamento de consentimento — 27/10/2026

O usuário indicou preferência pela opção de consentimento do responsável e explicou o uso escolar pelo professor. Esclareceu que a pesquisa pela UESC é uma possibilidade futura, sem análises ainda definidas e com consentimentos provavelmente ainda não elaborados. O PRD, a Tech Spec e a tarefa 6.0 passaram a distinguir operação educativa, autorização de responsável e pesquisa/banco formal. A necessidade atual dos dados precisa ser justificada; a possibilidade genérica de uso futuro não encerra essa avaliação. Não foram alterados os campos do produto, atribuídos novos consentimentos ou habilitado uso de pesquisa nesta atualização. A tarefa 6.0 continua pendente de definições do professor/UESC e do detalhamento do fluxo.
