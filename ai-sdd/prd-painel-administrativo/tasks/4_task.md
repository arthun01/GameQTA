# Tarefa 4.0: Motor de Banco de Dados das Questões

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Implementar as regras de banco de dados pesadas (Backend): as tabelas de Questão e Opções, e o validador customizado de que toda Questão precisa ter exatamente 1 opção correta e estar vinculada a um Tema.

## Requisitos Atendidos

- RF-009: Vinculada a um Tema obrigatório.
- RF-011: Mínimo 2 e máximo 5 opções por Questão.
- RF-012: Validação de exatamente 1 (uma) opção correta.

## Conformidade com Standards

- **AGENTS.md**: Regras de negócio vivem no Model! A validação de 1 opção correta deve ser um *Custom Validator* chamado no ciclo de salvamento do Model `Question`, e não algo checado no Controller.

## Subtarefas

- [x] 4.1 Gerar modelo `Question` (statement:text, youtube_link:string, feedback_article:text, difficulty:integer, theme:references).
- [x] 4.2 Configurar enum `difficulty` (easy: 0, medium: 1, hard: 2) no model.
- [x] 4.3 Gerar modelo `Option` (content:string, is_correct:boolean, question:references).
- [x] 4.4 Configurar `has_many :options, dependent: :destroy` em `Question`.
- [x] 4.5 Adicionar `accepts_nested_attributes_for :options, allow_destroy: true` em `Question`.
- [x] 4.6 Modificar `Theme` para `has_many :questions, dependent: :restrict_with_error`.
- [x] 4.7 Escrever um custom validator em `Question` que verifique se entre os `options` há entre 2 a 5 itens, e se exatamente 1 deles possui `is_correct == true`.

## Critérios de Sucesso

- [ ] Model `Question` aceita atributos aninhados de `Option`.
- [ ] Banco recusa salvar `Question` se as opções forem inválidas (0 corretas ou >1 correta).
- [ ] Todos os testes unitários da validação passando.

## Testes

### Testes Unitários
- [x] Salvar Questão sem opções corretas -> falha.
- [x] Salvar Questão com 2 opções corretas -> falha.
- [x] Salvar Questão com apenas 1 opção total -> falha (mínimo 2).
- [x] Salvar Questão com 1 opção correta e 3 incorretas -> passa com sucesso.

## Arquivos Relevantes
- `app/models/question.rb`
- `app/models/option.rb`
- `app/models/theme.rb`

## Dependências
- Tarefa 3.0: Modelo e CRUD de Temas

