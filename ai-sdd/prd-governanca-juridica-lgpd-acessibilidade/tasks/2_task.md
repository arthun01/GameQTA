# Tarefa 2.0: Navegação, impressão e documentação

> **Referências obrigatórias:** [PRD](../prd.md) e [Tech Spec](../techspec.md).

## Visão Geral

Permitir encontrar os documentos a partir das áreas existentes, imprimir seu conteúdo e consultar o estado real da entrega na documentação.

## Requisitos Atendidos

RF-001, RF-002, RF-008 e apresentação dos metadados de RF-007. Parte de RF-006 permanece dependente de canal real de atendimento.

## Design de Referência

Ver [design.md](../design.md), telas 1 a 3, origem Código. Acabamento posterior pelo colaborador responsável pelo Paper.

## Conformidade com Standards

Partial compartilhado e CSS de impressão, sem JavaScript inline ou alteração do sistema visual global. Testes de integração e Capybara.

## Subtarefas

- [x] 2.1 Incluir links nos layouts estudantil, administrativo e padrão.
- [x] 2.2 Criar apresentação para impressão preservando conteúdo e aviso de minuta.
- [x] 2.3 Testar navegação, contexto autenticado, viewport móvel e mídia de impressão.
- [x] 2.4 Atualizar README, índice de documentação e andamento das tarefas.
- [x] 2.5 Executar checks obrigatórios e registrar limitações anteriores.

## Detalhes de Implementação

Ver "Pontos de Integração" e "Abordagem de Testes" da Tech Spec. A impressão usa o comando do navegador; os links nas áreas existentes preservam formulários e partida abrindo em nova aba.

## Critérios de Sucesso

- [x] Links presentes nos logins, cadastro e áreas autenticadas dos dois perfis.
- [x] Documento utilizável em viewport móvel sem rolagem horizontal.
- [x] Impressão oculta menus e preserva versão, data, pendências e texto integral.
- [x] README informa a entrega parcial e as decisões pendentes.
- [x] Testes novos, suíte de integração e RuboCop passam; auditorias anteriores são registradas separadamente.

## Testes

### Testes de Integração

- [x] Presença dos links nos contextos públicos, estudantil e administrativo.

### Testes E2E

- [x] Login → documento → outro documento → seção.
- [x] Layout móvel e apresentação de impressão.

## Arquivos Relevantes

`shared/legal_links`, layouts, stylesheet jurídico, testes de integração e sistema, README, índice de documentação e arquivos AI-SDD.

## Dependências

Tarefa 1.0.

## Resultado

Links, impressão, documentação e verificações concluídos em 27/10/2026. Os dois testes novos de navegador passaram e a apresentação foi conferida em celular e computador. Ver [resultados completos](../tasks.md#validação-da-rodada--27102026), inclusive os problemas anteriores da suíte de navegador e das auditorias de dependências. Não há declaração de aprovação de todos os checks ou de adequação jurídica concluída.
