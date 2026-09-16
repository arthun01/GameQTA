# Tarefa 3.0: Dinâmica de Revelação e Cronômetro

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Injeção da etapa 2 (Avaliação). O aluno clica no botão "Mostrar Questão" que ativa o controller, salvando a hora inicial no banco e devolvendo a pergunta e o cronômetro para a UI.

## Design de Referência
Ver `ai-sdd/prd-gameplay-estudante/design.md`. Telas desta task:
- #2 Desafio - Passo 2: Avaliação — Origem: Paper — Ref: `9C-0`

## Requisitos Atendidos

- RF-002: Exibir cronômetro regressivo visível e submissão automática se acabar o tempo.
- RF-003: Fluxo dinâmico sem reload usando Turbo.

## Conformidade com Standards

- **turbo-patterns**: Uso rigoroso de `turbo_stream.update` para injetar o conteúdo de avaliação no local adequado sem reload total da página.
- **stimulus-patterns**: Controller Stimulus genérico, autossuficiente e testável para contar o tempo.

## Subtarefas

- [ ] 3.1 Adicionar Action `reveal` em `Play::QuestionsController` que encontra a tentativa, salva `revealed_at = Time.current` em um `QuestionSubmission` provisório, e renderiza Turbo Stream.
- [ ] 3.2 Criar a View/Partial de revelação baseada no artboard `9C-0` do Paper.
- [ ] 3.3 Criar o controller Stimulus `gameplay_timer_controller.js`.
- [ ] 3.4 Conectar o Stimulus ao HTML para ler o tempo base da dificuldade (`data-gameplay-timer-seconds-value`) da configuração global (`GameSetting`), diminuir segundo a segundo, e fazer um `.requestSubmit()` do form quando chegar em 0.

## Detalhes de Implementação

- **Referência**: Ver "Decisões Principais" na `techspec.md`.
- **Pontos de atenção**: Certifique-se de que o Stimulus aciona o submit exato no momento em que chega a 0, não após.

## Critérios de Sucesso

- [ ] O clique no botão "Mostrar Questão" imediatamente injeta a área de alternativas e encolhe a área do vídeo de consumo sem reload.
- [ ] O contador regressivo JS flui suavemente e ativa o submit no tempo esgotado.
- [ ] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes de Integração
- [ ] Post para `reveal` cria um submission frame com `revealed_at` e retorna a Turbo Stream de atualização.

### Testes E2E (se aplicável)
- [ ] System test verificando que após 1 segundo na tela, o contador muda visualmente (pode ser com mock da velocidade).

## Arquivos Relevantes

- `app/controllers/play/questions_controller.rb` — Modificado
- `app/views/play/questions/reveal.turbo_stream.erb` — Novo
- `app/views/play/questions/_evaluation.html.erb` — Novo
- `app/javascript/controllers/gameplay_timer_controller.js` — Novo

## Dependências

- Tarefa 2.0: Motor de Inicialização e Tela de Consumo

