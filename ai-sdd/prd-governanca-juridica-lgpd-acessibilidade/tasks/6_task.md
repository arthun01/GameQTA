# Tarefa 6.0: Autorização de responsáveis e exposição de menores

> Referências obrigatórias: [PRD](../prd.md), [Tech Spec](../techspec.md) e [Design](../design.md).

## Visão Geral

Entrega incremental do tópico 2, conforme a seção "Evolução do tópico 2" da Tech Spec.

## Requisitos Atendidos

RF-013, RF-014 e RF-018. As pendências jurídicas e operacionais permanecem explícitas.

## Design de Referência

Telas 4 a 7 de design.md, origem Texto/Código, conforme a parte aplicável. Sem dependência do Paper.

## Conformidade com Standards

Models com regras de domínio, controllers REST, i18n, ERB e Minitest com fixtures. Sem services ou alteração manual do schema.

## Subtarefas

- [ ] 6.1 Definir com o usuário verificação do vínculo e faixas etárias.
- [ ] 6.2 Registrar procedimento operacional e validações pendentes.
- [ ] 6.3 Detalhar e implementar somente após as definições necessárias.
- [ ] 6.4 Validar autorização, restrições, revogação e exposição dos menores.

## Detalhes de Implementação

Ver interfaces, dados e testes da evolução do tópico 2 na Tech Spec. Não registrar aceite retroativo nem simular atendimento ou autorização de responsável.

## Critérios de Sucesso

- [ ] Cenários funcionais e de recusa previstos nas subtarefas passam.
- [ ] Resultados e limitações são registrados em tasks.md.

## Testes

### Testes Unitários
- [ ] Regras de domínio e conservação dos dados quando a ação é recusada.

### Testes de Integração
- [ ] Autenticação, parâmetros permitidos, respostas de erro e sucesso.

### Testes E2E
- [ ] Fluxo aplicável no navegador com dados de teste.

## Arquivos Relevantes

Ver lista de componentes da evolução do tópico 2 na Tech Spec, incluindo User, controllers de users, views e testes.

## Dependências

Conforme o quadro de tasks.md. Para menores, aguardar definição operacional com o usuário.


## Direcionamento atualizado — 27/10/2026

- O usuário prefere a opção de consentimento do responsável quando aplicável, com experiência educativa simples.
- O professor usará o projeto em escolas. Eventual pesquisa será pela UESC, mas não há análises definidas e a existência dos termos de consentimento/protocolo ainda precisa ser confirmada com ele.
- Não tornar dados obrigatórios nem criar autorização ampla por poderem ser úteis futuramente. Reavaliar a necessidade e a finalidade atual de idade, cidade e escolaridade; preservar os valores existentes enquanto se define seu tratamento.
- A escola pode apoiar a obtenção e a conferência da autorização; não representar automaticamente o responsável legal.
- Separar o aceite dos documentos, autorização educativa e consentimento de pesquisa. Um banco para pesquisas futuras depende de propósito delimitado e governança definida pelo professor/UESC, com regras jurídicas e éticas próprias.
- Antes da implementação, confirmar instituição/controlador por finalidade, finalidade e campos necessários, termos e procedimento de verificação, participação/assentimento aplicável, revogação, acesso e retenção. Não presumir aprovação ética ou autorização retroativa.

A tarefa continua pendente. Esta rodada atualizou somente os documentos de planejamento; a implementação de consentimentos específicos permanece por detalhar.
