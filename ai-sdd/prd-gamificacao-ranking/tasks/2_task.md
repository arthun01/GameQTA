# Tarefa 2.0: Motor de Atualização Assíncrona (Job)

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Implementação da lógica core do ranking: um worker em background que calcula a pontuação por dificuldade e as penalidades de tempo total, atualizando o cache (Leaderboard) de um usuário específico sempre que necessário.

## Requisitos Atendidos

- RF-001: Tabela base de pontos (Fácil=10, Médio=20, Difícil=30).
- RF-002: Não computar pontos para questões incorretas.
- RF-003: Somar todos os pontos.
- RF-004: Calcular o Tempo Total Investido de todas tentativas.

## Conformidade com Standards

- **AGENTS.md**: O projeto dispensa services em favor de concerns ou jobs. Aqui a lógica principal de consolidação fica encapsulada no próprio Job, atuando sobre métodos nativos dos models de forma enxuta.

## Subtarefas

- [x] 2.1 Criar o job `Leaderboards::UpdateUserJob`.
- [x] 2.2 Implementar a lógica de cálculo: buscar as submissões corretas do aluno e fazer o JOIN com `Question` para mapear a dificuldade e aplicar o score.
- [x] 2.3 Implementar a lógica de soma de tempo de *todas* as submissões (`time_taken`).
- [x] 2.4 Fazer o `upsert` na tabela `Leaderboard` para não duplicar o registro do `user_id`.
- [x] 2.5 Configurar o callback (`after_commit on: :create`) no `QuestionSubmission` para chamar `UpdateUserJob.perform_later(theme_attempt.user_id)`.

## Detalhes de Implementação

- **Referência**: Ver "Interfaces Principais" no `techspec.md`.
- **Pontos de atenção**: Certifique-se de que a query de agregação não sofra de N+1 e prefira `sum()` no banco em vez de Ruby iterando nos registros para eficiência.

## Critérios de Sucesso

- [x] Submissões corretas recebem score (10/20/30) proporcional e somam no Leaderboard do usuário de forma correta e atualizada.
- [x] O tempo total reflete as submissões independentemente da sua corretude.
- [x] O job é ativado via Solid Queue.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes Unitários
- [x] UpdateUserJobTest: Passar um UserID de uma fixture que tenha uma submissão de cada nível (fácil/médio/difícil), certas e erradas. Afirmar que o total de tempo bate com a soma de todas e o score reflete a regra específica do RF.
- [x] QuestionSubmissionTest: Checar se o callback está realmente enfileirando a execução assíncrona.

## Arquivos Relevantes

- `app/jobs/leaderboards/update_user_job.rb` — Novo
- `test/jobs/leaderboards/update_user_job_test.rb` — Novo
- `app/models/question_submission.rb` — Modificado — Callback adicionado
- `test/models/question_submission_test.rb` — Modificado

## Dependências

- Tarefa 1.0: Infraestrutura de Dados do Leaderboard — Requer a tabela `Leaderboard` e as fixtures do usuário.
