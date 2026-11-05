# Tarefa 3.0: Aceite versionado e contas existentes

> Referências obrigatórias: [PRD](../prd.md), [Tech Spec](../techspec.md) e [Design](../design.md).

## Visão Geral

Entrega incremental do tópico 2, conforme a seção "Evolução do tópico 2" da Tech Spec.

## Requisitos Atendidos

RF-007 e RF-010 a RF-012. As pendências jurídicas e operacionais permanecem explícitas.

## Design de Referência

Telas 4 a 7 de design.md, origem Texto/Código, conforme a parte aplicável. Sem dependência do Paper.

## Conformidade com Standards

Models com regras de domínio, controllers REST, i18n, ERB e Minitest com fixtures. Sem services ou alteração manual do schema.

## Subtarefas

- [x] 3.1 Registrar versões, instante e cópia do texto no servidor.
- [x] 3.2 Rejeitar aceite ausente ou referente a revisão desatualizada.
- [x] 3.3 Solicitar manifestação de contas antigas, preservando perfil, exclusão e documentos.
- [x] 3.4 Testar cadastro, reaceite, histórico, falhas e parâmetros forjados.

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
