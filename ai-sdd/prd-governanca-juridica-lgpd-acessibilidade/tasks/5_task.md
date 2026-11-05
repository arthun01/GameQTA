# Tarefa 5.0: Exclusão segura e jobs pendentes

> Referências obrigatórias: [PRD](../prd.md), [Tech Spec](../techspec.md) e [Design](../design.md).

## Visão Geral

Entrega incremental do tópico 2, conforme a seção "Evolução do tópico 2" da Tech Spec.

## Requisitos Atendidos

RF-016 e parte de RF-017. As pendências jurídicas e operacionais permanecem explícitas.

## Design de Referência

Telas 4 a 7 de design.md, origem Texto/Código, conforme a parte aplicável. Sem dependência do Paper.

## Conformidade com Standards

Models com regras de domínio, controllers REST, i18n, ERB e Minitest com fixtures. Sem services ou alteração manual do schema.

## Subtarefas

- [x] 5.1 Exigir senha e confirmação antes da exclusão.
- [x] 5.2 Apagar dados associados e encerrar todas as sessões em transação.
- [x] 5.3 Proteger atualização do ranking contra contas excluídas ou bloqueadas.
- [x] 5.4 Testar remoção, isolamento de terceiros, jobs e fluxo no navegador.

## Detalhes de Implementação

Ver interfaces, dados e testes da evolução do tópico 2 na Tech Spec. Não registrar aceite retroativo nem simular atendimento ou autorização de responsável.

## Critérios de Sucesso

- [x] Cenários funcionais e de recusa previstos nas subtarefas passam.
- [x] Resultados e limitações são registrados em tasks.md.

## Testes

### Testes Unitários
- [x] Regras de domínio e conservação dos dados quando a ação é recusada.

### Testes de Integração
- [x] Autenticação, parâmetros permitidos, respostas de erro e sucesso.

### Testes E2E
- [x] Fluxo aplicável no navegador com dados de teste.

## Arquivos Relevantes

Ver lista de componentes da evolução do tópico 2 na Tech Spec, incluindo User, controllers de users, views e testes.

## Dependências

Conforme o quadro de tasks.md. Para menores, aguardar definição operacional com o usuário.


## Resultado

Implementação técnica validada em 27/10/2026. Ver resultados desta rodada em [tasks.md](../tasks.md). Os cenários novos passam; limitações jurídicas, operacionais e da suíte global estão registradas separadamente. A autorização de responsáveis continua pendente na tarefa 6.0.
