# Tech Spec - Gamificação e Ranking Global

## Resumo Executivo

Esta especificação define a arquitetura técnica para a Fase 4 (Gamificação e Ranking). A solução utiliza uma tabela de cache otimizada (`Leaderboard`) para armazenar a pontuação e o tempo total de cada estudante. Esta tabela é atualizada de forma assíncrona (via Solid Queue) sempre que uma nova resposta for submetida, transferindo o custo de processamento das somas para o background. Na leitura, a tela de Ranking faz uma consulta de alta performance aos top 10 e utiliza uma `Window Function` (DENSE_RANK) nativa do PostgreSQL para descobrir a posição do aluno corrente, caso ele esteja fora do Top 10.

## Design de Referência

A implementação deve seguir os protótipos visuais documentados e aprovados:

- Ver: `ai-sdd/prd-gamificacao-ranking/design.md`
- **Telas Mapeadas:**
  - `Tela de Ranking` — Origem: Paper Desktop (Artboard `BB-0`)

## Arquitetura do Sistema

### Visão Geral dos Componentes

- **`Leaderboard` (Model)**: Nova tabela de cache que armazena a pontuação pré-calculada e tempo investido de cada usuário. — *Novo*
- **`Leaderboards::UpdateUserJob` (Job)**: Processa de forma assíncrona o recálculo do score/time_taken do usuário e dá upsert no registro de Leaderboard correspondente. — *Novo*
- **`QuestionSubmission` (Model)**: Aciona (enfileira) o job de atualização no callback `after_commit, on: :create`. — *Modificado*
- **`RankingsController` (Controller)**: Busca o Top 10 e a posição do current_user de maneira eficiente, passando para a View. — *Novo*
- **`rankings/index` (View)**: Renderiza a lista de alunos e a posição fixada baseada no design do Paper. — *Novo*

## Design de Implementação

### Modelos de Dados

- **Entidade `Leaderboard`**
  ```ruby
  # leaderboards
  # - user_id: bigint, not null, unique
  # - total_score: integer, default: 0, not null
  # - total_time_taken: integer, default: 0, not null
  #
  # relationships
  # - belongs_to :user
  #
  # indexes
  # - [:total_score, :total_time_taken], order: { total_score: :desc, total_time_taken: :asc }
  ```

### Interfaces Principais

```ruby
# app/jobs/leaderboards/update_user_job.rb
module Leaderboards
  class UpdateUserJob < ApplicationJob
    queue_as :default

    def perform(user_id)
      # Calcula a soma baseada na dificuldade (Apenas acertos)
      # Fácil=10, Médio=20, Difícil=30
      
      # Calcula a soma do time_taken de TODAS as question_submissions do usuário
      
      # Leaderboard.upsert(
      #   { user_id: user_id, total_score: score, total_time_taken: time },
      #   unique_by: :user_id
      # )
    end
  end
end
```

### Endpoints / Rotas

| Método | Rota | Controller#Action | Descrição |
|--------|------|-------------------|-----------|
| GET | `/ranking` | `rankings#index` | Tela do Ranking (Top 10 + Current User Position) |

*Ref: RF-006, RF-007, RF-008, RF-009*

## Abordagem de Testes

### Testes Unitários

- **Model `Leaderboard`**: Validações de presença, belongs_to user.
- **Job `Leaderboards::UpdateUserJob`**: Criar fixtures de submissions variadas (certas, erradas, níveis diferentes) e testar se o Job calcula corretamente os pontos e o tempo total, inserindo/atualizando a tabela Leaderboard.

### Testes de Integração

- **Controller `RankingsController`**:
  - Testar se retorna exatamente 10 registros.
  - Testar a ordenação do Top 10 (primeiro ordenado por `total_score` decrescente, e desempate por `total_time_taken` crescente).
  - Verificar a window function, testando a posição de um user rankeado na posição 15º.

### Testes E2E

- **Testes de Sistema**:
  - `ranking_test.rb`: Login como estudante, navegação via menu para `/ranking`. Garantir que o pódio Top 3 tenha destaque visual e que o card "Sua Posição" esteja visível.

## Sequenciamento de Desenvolvimento

### Ordem de Construção

1. **Model `Leaderboard` e Migrações**: Base do cache (RF-001 a RF-005).
2. **`Leaderboards::UpdateUserJob`**: Lógica pesada de cálculo isolada. Adição do callback no `QuestionSubmission`.
3. **`RankingsController` e Window Function**: Query do Postgres para a lista de Top 10 e subquery da posição específica.
4. **Views e Integração de Design**: Mapear o Paper Artboard (BB-0) e componentes visuais de `rankings/index.html.erb` usando Tailwind CSS.

## Considerações Técnicas

### Decisões Principais

| Decisão | Escolha | Justificativa | Alternativas Rejeitadas |
|---------|---------|---------------|------------------------|
| Cálculo da pontuação | Job Assíncrono e Cache Table (`Leaderboard`) | Garante que a página do ranking seja carregada instantaneamente, independente de quantos usuários ou submissões existam. | Calcular os JOINs via SQL na view em tempo real (pouco escalável e pode onerar o BD principal). |
| Consulta da Posição do Estudante (>10) | Window Function `DENSE_RANK() OVER` | Uma única passagem pelo BD entrega a classificação exata sem depender de manipulação via código Ruby (Altamente performático e preciso no Postgres). | Consulta simples `COUNT(*) WHERE score > X` (Menos preciso para gerenciar desempates duplos). |

### Riscos Conhecidos

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------| 
| Inconsistência do Cache se Jobs falharem | Baixa | Médio | Como a fonte da verdade (`QuestionSubmission`) persiste de forma segura, podemos criar uma rake task para reconstruir os registros de `Leaderboard` em massa, se necessário. |

### Conformidade com Standards do Projeto

- **Jobs Mínimos**: Em `AGENTS.md` a diretriz é que Jobs sejam rasos, chamando métodos de model. Contudo, dado o caráter de agregação e upsert desta funcionalidade em uma tabela separada (`Leaderboard`), a lógica será tratada como operação simples do Job manipulando um query object ou upsert direto.
- **Testes**: Uso estrito do Minitest e Fixtures conforme exigido no `AGENTS.md`. Não usar service objects (sem pasta `app/services`).
