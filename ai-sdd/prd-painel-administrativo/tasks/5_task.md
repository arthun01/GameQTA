# Tarefa 5.0: Formulário Dinâmico e Frontend das Questões

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Construir a camada visual para gerenciar as Questões. O grande desafio aqui é o controlador Stimulus que lidará com a adição/remoção de opções na tela, além de garantir visualmente o comportamento de resposta única.

## Requisitos Atendidos

- RF-008: CRUD de Questões
- RF-010: Campos obrigatórios do formulário (incluindo YouTube link e opções dinâmicas).

## Design de Referência
Ver `ai-sdd/prd-painel-administrativo/design.md`. Telas desta task:
- #3 Lista de Questões (Drill-down) — Origem: Paper — Ref: `2C-0`
- #4 Formulário de Questão — Origem: Paper — Ref: `3I-0`

## Conformidade com Standards

- **AGENTS.md**: Sem JavaScript inline. Use um Stimulus Controller (`nested_form_controller.js`) para gerenciar a adição de campos de form aninhados baseados num elemento `<template>`.

## Subtarefas

- [x] 5.1 Criar o `Admin::QuestionsController` (listando questões para um Tema, via shallow nesting).
- [x] 5.2 Desenvolver a view `index` baseada no Artboard 3 (exibindo badges de dificuldade e qtd de opções).
- [x] 5.3 Criar a view de `_form` (Artboard 4) com os campos padrões da `Question`.
- [x] 5.4 Gerar um Stimulus Controller (`bin/rails generate stimulus nested_form`) para lidar com o DOM de inserção/remoção dos campos `fields_for :options`.
- [x] 5.5 Garantir que a UI que controla `is_correct` esteja agrupada logicamente (ex: radio buttons) para facilitar a experiência do usuário.
- [x] 5.6 Mapear a renderização de erros de validação (RF-12) para que o admin entenda por que o formulário falhou.

## Critérios de Sucesso

- [x] Admin consegue acessar o formulário, clicar em "Adicionar Opção" e novos campos surgem via Stimulus.
- [x] Submissão do formulário salva a Questão e as Opções aninhadas corretamente.
- [x] Erros de validação do banco (ex: esquecer de marcar a correta) refletem na view.

## Testes

### Testes E2E (Sistema - Capybara)
- [x] Acessar formulário, preencher enunciado, adicionar 3 opções dinamicamente via JS, marcar uma como correta e salvar -> Questão é listada com sucesso no index.

## Arquivos Relevantes
- `app/controllers/admin/questions_controller.rb`
- `app/javascript/controllers/nested_form_controller.js`
- `app/views/admin/questions/_form.html.erb`
- `app/views/admin/questions/index.html.erb`

## Dependências
- Tarefa 4.0: Motor de Banco de Dados das Questões

