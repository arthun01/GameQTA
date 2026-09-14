# Tarefa 3.0: Motor de Progresso Base (Backend)

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Fornecer os dados necessários (Níveis e Temas) para a interface principal do Aluno e calcular logicamente qual nível está aberto.

## Requisitos Atendidos

- RF-006: Nível 1 desbloqueado.
- RF-007: Outros níveis bloqueados.

## Conformidade com Standards

- **AGENTS.md**: "Lógica de negócio vive nos models". A função de detectar qual é o primeiro nível deve estar no model `Level`.

## Subtarefas

- [x] 3.1 Adicionar método no model `Level` (ex: `starting_level?`) que avalia se a instância atual é o `Level.order(:created_at).first` (ou `:id`).
- [x] 3.2 Criar rota `get "/jornada", to: "dashboard#index"` e assegurar que o `root to:` aponta/redireciona para cá.
- [x] 3.3 Construir `DashboardController` assegurando que ele herde de `Users::BaseController` para garantir que apenas alunos logados acessem.
- [x] 3.4 Na action `index`, carregar os níveis fazendo preload de seus temas para evitar N+1: `@levels = Level.includes(:themes).order(:created_at)`.

## Detalhes de Implementação

- **Referência**: Ver "Dashboard" na Tech Spec.
- **Pontos de atenção**: Evite lógicas complexas no Controller. Retorne a lista de níveis para a view e deixe o helper ou a iteração baseada em `starting_level?` guiar o status visual (Task 4).

## Critérios de Sucesso

- [x] Tentar acessar `/jornada` deslogado redireciona para `/entrar`.
- [x] Acessar `/jornada` logado carrega `@levels` e `@levels.first.starting_level?` retorna `true`.
- [x] Todos os testes unitários passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes Unitários
- [x] `LevelTest`: Garantir que `starting_level?` aponta corretamente para o primeiro nível inserido, ignorando a deleção caso seja implementada (o segundo mais antigo assume a função).

### Testes de Integração
- [x] `DashboardControllerTest`: Validar o preload da query e a autorização de sessão (bloqueio se deslogado).

## Arquivos Relevantes

- `app/models/level.rb` — Modificado
- `app/controllers/dashboard_controller.rb` — Novo

## Dependências

- Tarefa 2.0: Autenticação (para a herança do BaseController)

