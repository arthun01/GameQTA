# Tarefa 1.0: Infraestrutura de Dados do Leaderboard

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Criação da base de dados que sustentará a leitura ultrarrápida do ranking. Em vez de calcular sumatórios na visualização, teremos a tabela `Leaderboard` servindo como um cache inteligente indexado por pontos e tempo.

## Requisitos Atendidos

- RF-001: Estabelecer pontuação de dificuldade.
- RF-003: Somar pontos de questões acertadas.
- RF-004: Somar o tempo total investido.
*(Nota: A regra de cálculo será executada na tarefa 2.0, esta tarefa cobre a persistência do cálculo).*

## Conformidade com Standards

- **AGENTS.md**: Migrações sem modificações manuais diretas na estrutura do SQL ou `schema.rb`, seguindo padrões ativos de banco do Rails. Tabela e model nomeados no singular (`Leaderboard`) seguindo a convenção.

## Subtarefas

- [ ] 1.1 Gerar a migration e o model `Leaderboard` associado ao `User`.
- [ ] 1.2 Definir valores default para `total_score` (0) e `total_time_taken` (0).
- [ ] 1.3 Criar índices combinados na migration: index ordenando `total_score` de forma decrescente e `total_time_taken` de forma crescente.
- [ ] 1.4 Adicionar a associação `has_one :leaderboard` no model `User`.

## Detalhes de Implementação

- **Referência**: Ver seção "Modelos de Dados" em `techspec.md` para visualizar as colunas.
- **Pontos de atenção**: Assegurar que os defaults do banco (0) e restrições `null: false` sejam aplicados corretamente na migration.

## Critérios de Sucesso

- [ ] Tabela `leaderboards` criada com todas as colunas requisitadas.
- [ ] O model valida presença de relacionamentos com `User`.
- [ ] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes Unitários
- [ ] Model Leaderboard: Testar asserções básicas de presença de usuário. Validação do escopo.

## Arquivos Relevantes

- `db/migrate/*_create_leaderboards.rb` — Novo — Migration de estrutura e index
- `app/models/leaderboard.rb` — Novo — Model ActiveRecord
- `app/models/user.rb` — Modificado — Adicionar has_one
- `test/models/leaderboard_test.rb` — Novo — Testes

## Dependências

- Nenhuma.
