# Tarefa 1.0: Documentos públicos e minutas localizadas

> **Referências obrigatórias:** [PRD](../prd.md) e [Tech Spec](../techspec.md).

## Visão Geral

Disponibilizar termos e privacidade sem login, com conteúdo que descreva a aplicação atual e destaque as decisões ainda indefinidas.

## Requisitos Atendidos

RF-001 a RF-005, informação sobre direitos de RF-006, metadados de RF-007 e RF-008. O canal de atendimento e o registro de aceite não fazem parte da conclusão técnica desta tarefa.

## Design de Referência

Ver [design.md](../design.md), telas 1 e 2, origem Código. O usuário adiou o Paper e autorizou implementação direta.

## Conformidade com Standards

Controllers REST com `show`, partials ERB, i18n, identidade existente e Minitest. Sem models ou migrações para conteúdo estático.

## Subtarefas

- [x] 1.1 Criar os recursos públicos e layout de leitura.
- [x] 1.2 Escrever minutas em i18n com inventário real, versão, data e pendências.
- [x] 1.3 Criar e executar testes de acesso, conteúdo e navegação entre documentos.

## Detalhes de Implementação

Ver "Arquitetura do Sistema" e "Interfaces Principais" na Tech Spec. Sem e-mail fictício, confirmação de consentimento ou promessas sobre funcionalidades futuras.

## Critérios de Sucesso

- [x] Ambas as rotas retornam 200 sem login e não criam contas ou sessões de autenticação.
- [x] Termos e privacidade têm conteúdo, título, metadados e aviso de minuta.
- [x] Direitos e limitações atuais são apresentados sem simular canal de atendimento.
- [x] Testes de integração passam.

## Testes

### Testes de Integração

- [x] Acesso anônimo, conteúdo de cada documento, metadados e links internos válidos.
- [x] Aviso de pendência e ausência de formulário ou e-mail fictício.

## Arquivos Relevantes

Controllers `terms` e `privacy_policies`, respectivas views, partial `legal_documents/document`, layout jurídico, locale e testes de integração.

## Dependências

Nenhuma tarefa anterior. Definições institucionais pendentes são limitações da minuta, não dados a inventar.

## Resultado

Implementação e testes concluídos em 27/10/2026. Os sete testes novos de integração passaram também na suíte Rails completa. Ver [resultados e limitações da rodada](../tasks.md#validação-da-rodada--27102026).
