# Tarefa 1.0: Infraestrutura de Dados (Modelagem e Settings)

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Criação dos modelos fundamentais para registrar o progresso e as configurações do jogo: `ThemeAttempt`, `QuestionSubmission` e `GameSetting`. Essa camada de persistência será a base para todo o resto do motor.

## Requisitos Atendidos

- RF-004: Armazenar resposta e tempo do aluno (Parcial)
- RF-008: Calcular progresso do Nível (Estrutura)
- RF-010: Persistência de estado de jogo (Estrutura)

## Conformidade com Standards

- **AGENTS.md**: Sem uso de `app/services/` e testes feitos com Minitest/Fixtures.

## Subtarefas

- [x] 1.1 Gerar e executar migration para `ThemeAttempt` (user, theme, status).
- [x] 1.2 Gerar e executar migration para `QuestionSubmission` (theme_attempt, question, option, is_correct, revealed_at, time_taken).
- [x] 1.3 Gerar e executar migration para `GameSetting` (tempos fáceis, médios e difíceis).
- [x] 1.4 Configurar Models com `belongs_to`, `has_many`, e validação.
- [x] 1.5 Adicionar dados aos arquivos `.yml` (fixtures) correspondentes para popular nos testes.

## Detalhes de Implementação

- **Referência**: Ver seção "Modelos de Dados" em `techspec.md`.
- **Pontos de atenção**: O `GameSetting` deve poder ser criado com defaults caso a tabela esteja vazia (ex: easy: 60s, medium: 45s, hard: 30s).

## Critérios de Sucesso

- [x] Estrutura do banco criada com chaves estrangeiras e índices.
- [x] Models salvam com sucesso no console do Rails.
- [x] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes Unitários
- [x] Testar a obrigatoriedade de status default (`in_progress`) no `ThemeAttempt`.
- [x] Validar unicidade da `question_id` no escopo do `theme_attempt_id` em `QuestionSubmission`.

## Arquivos Relevantes

- `db/migrate/` — Novo — Migrations
- `app/models/theme_attempt.rb` — Novo
- `app/models/question_submission.rb` — Novo
- `app/models/game_setting.rb` — Novo
- `test/models/theme_attempt_test.rb` — Novo
- `test/fixtures/theme_attempts.yml` — Novo

## Dependências

- Nenhuma

