# Tarefa 2.0: Motor de Inicialização e Tela de Consumo

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Desenvolvimento do fluxo de entrada no jogo. O aluno clica para iniciar um Tema, uma tentativa (`ThemeAttempt`) é gerada, e a primeira questão não respondida é buscada para apresentar o vídeo de consumo.

## Design de Referência
Ver `ai-sdd/prd-gameplay-estudante/design.md`. Telas desta task:
- #1 Desafio - Passo 1: Consumo — Origem: Paper — Ref: `9B-0`

## Requisitos Atendidos

- RF-001: Ao iniciar o nível, o estudante deve passar por um Tema visualizando a questão dividida em Consumo e Avaliação.

## Conformidade com Standards

- **AGENTS.md**: Lógica restrita no Controller focada nas views, usando locales i18n na view.

## Subtarefas

- [x] 2.1 Criar rotas no namespace `play` (themes e theme_attempts).
- [x] 2.2 Implementar `Play::ThemesController#start` que encontra ou cria um `ThemeAttempt` `in_progress` para o tema em questão.
- [x] 2.3 Implementar lógica no model `ThemeAttempt` para `next_pending_question`.
- [x] 2.4 Implementar `Play::QuestionsController#show` que renderiza o layout e o vídeo em um Turbo Frame principal.
- [x] 2.5 Desenhar a View `show.html.erb` (Desafio - Passo 1: Consumo) baseada no design `9B-0` do Paper.

## Detalhes de Implementação

- **Referência**: Ver "Visão Geral dos Componentes" e "Endpoints" na `techspec.md`.
- **Pontos de atenção**: O botão "Mostrar Questão" deverá fazer um request assíncrono pro Turbo no endpoint `reveal` da Tarefa 3.0. Por hora, apenas o desenhe e aponte para lá.

## Critérios de Sucesso

- [x] Clicar num Tema na Home do Estudante (`/dashboard`) direciona ao `start` e logo pro `show` da questão.
- [x] UI reproduz fielmente o artboard `9B-0` do Paper.
- [x] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes de Integração
- [x] Post para `start` redireciona para a questão pendente.
- [x] Get em `show` de uma tentativa que não pertence ao current_user dá erro (autorização).
- [x] Get em `show` mostra o vídeo do youtube e o botão "Mostrar Questão".

## Arquivos Relevantes

- `config/routes.rb` — Modificado
- `app/controllers/play/themes_controller.rb` — Novo
- `app/controllers/play/questions_controller.rb` — Novo
- `app/views/play/questions/show.html.erb` — Novo
- `app/models/theme_attempt.rb` — Modificado

## Dependências

- Tarefa 1.0: Infraestrutura de Dados

