# Especificação Técnica - Correções de Progressão, Segurança de Gameplay e Estabilidade

## Visão Geral Técnica

Esta especificação detalha as alterações nas camadas de Model, Controller, View, Helper, I18n e Testes para corrigir o desbloqueio de níveis, blindar o motor de gameplay contra bypass de URL, sincronizar o `Leaderboard` em exclusões/resets, validar o model `Admin` e higienizar o repositório.

---

## 1. Camada de Models

### 1.1. `Theme` (`app/models/theme.rb`)
Adicionar método para verificar se um tema foi efetivamente concluído por um estudante:
- `completed_by?(user)`:
  - Retorna `false` se `user.nil?`.
  - Verifica se existe um `theme_attempts.completed.where(user: user)` cuja quantidade de `question_submissions` respondidas (`where.not(answered_at: nil)`) seja igual a `questions.count` (e `questions.any?`).

### 1.2. `Level` (`app/models/level.rb`)
Corrigir o cálculo de nota e implementar os métodos de progressão entre níveis:
- `previous_level`:
  - `Level.where("id < ?", id).order(id: :desc).first`
- `score_for(user)`:
  - Total de questões do nível: `total_questions = Question.where(theme_id: themes.select(:id)).count`.
  - Retorna `0.0` se `total_questions.zero?` ou `user.nil?`.
  - Obtém o `id` da tentativa **concluída** (`completed`) mais recente de cada tema do nível para o `user` (ou a tentativa mais recente caso esteja sendo avaliada no `finish`).
  - Soma as `QuestionSubmission` com `is_correct: true` pertencentes a essas tentativas.
  - Retorna `((correct.to_f / total_questions) * 100).round(1)`.
- `all_themes_completed_by?(user)`:
  - Retorna `false` se `user.nil?` ou `themes.empty?`.
  - Verifica se todos os temas do nível satisfazem `theme.completed_by?(user)`.
- `completed_by?(user)`:
  - Retorna `all_themes_completed_by?(user) && score_for(user) >= 70.0`.
- `unlocked_for?(user)`:
  - Retorna `true` se `starting_level?`.
  - Caso contrário, retorna `previous_level.present? && previous_level.completed_by?(user) && previous_level.unlocked_for?(user)`.
- `reset_progress_for!(user)`:
  - Dentro de `ThemeAttempt.transaction`, destrói as tentativas do usuário nos temas do nível e agenda `Leaderboards::UpdateUserJob.perform_later(user.id)`.

### 1.3. `QuestionSubmission` (`app/models/question_submission.rb`) e `User` (`app/models/user.rb`)
- Em `QuestionSubmission`:
  - Alterar o callback para `after_commit :update_leaderboard, on: %i[ create update destroy ]`.
  - Em `answer(option_id:)`: calcular a pontuação da questão (`10` para `easy`, `20` para `medium`, `30` para `hard` quando `selected&.is_correct?`, ou `0` caso contrário) e persistir no atributo `score`.
- Em `User#update_leaderboard`:
  - Atualizar também `update_column(:total_score, total_score)` no registro do `User` para manter `users.total_score` sincronizado com `leaderboards.total_score`.

### 1.4. `Admin` (`app/models/admin.rb`)
- Adicionar validações:
  ```ruby
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { maximum: 254 }
  ```

---

## 2. Camada de Controllers

### 2.1. `Play::ThemesController` (`app/controllers/play/themes_controller.rb`)
- Em `start`:
  - Verificar `unless @theme.level.unlocked_for?(Current.user)` $\rightarrow$ redirecionar para `jornada_path` com `alert: t(".level_locked")`.
- Em `finish`:
  - Se `@attempt.nil?`, redirecionar para `jornada_path`.
  - Se `@attempt.next_pending_question.present?`, redirecionar para `play_theme_attempt_question_path(@attempt)` (impedindo conclusão prematura sem responder todas as questões do tema).
  - Marcar `@attempt.update!(status: :completed)` se `@attempt.in_progress?`.
  - Verificar se **todos os temas do nível foram concluídos** (`@level.all_themes_completed_by?(Current.user)`) ou se é o último tema:
    - Quando `@level.all_themes_completed_by?(Current.user)`:
      - Calcular `@score = @level.score_for(Current.user)`.
      - Se `@score < 70.0`, chamar `@level.reset_progress_for!(Current.user)` e `@passed = false`.
      - Caso contrário, `@passed = true`.
    - Se ainda houver outros temas pendentes no nível:
      - Redirecionar para `jornada_path` com `notice: t(".theme_completed")`.

### 2.2. `Admin::LevelsController` (`app/controllers/admin/levels_controller.rb`)
- Em `destroy`:
  - Verificar `if @level.destroy` $\rightarrow$ `notice: t(".success")`, caso contrário $\rightarrow$ `alert: t(".error")` com `status: :see_other`.

### 2.3. `Admin::DashboardsController` (`app/controllers/admin/dashboards_controller.rb`)
- Alterar `@themes_completed = ThemeAttempt.completed.count`.

### 2.4. `Admin::ReportsController` (`app/controllers/admin/reports_controller.rb`)
- Adicionar método privado `sanitize_csv_field(value)` que prefixa `'` quando uma `String` começa com `=`, `+`, `-`, `@`, `\t` ou `\r`.

---

## 3. Camada de Views, Helpers e Assets

### 3.1. `ApplicationHelper` (`app/helpers/application_helper.rb`)
- Atualizar `level_image_path(level_or_position)`:
  - Aceitar um objeto `Level` ou índice inteiro `1..5`, mapeando pela ordem do nível (`Level.order(:id).pluck(:id).index(level.id)&.+ 1`) para exibir `ods-1.png` a `ods-5.png` independentemente do ID primário da tabela.

### 3.2. `app/views/dashboard/index.html.erb`
- Substituir `<% if level.starting_level? %>` por `<% if level.unlocked_for?(Current.user) %>`.
- Exibir badge `Concluído` quando `level.completed_by?(Current.user)` e `Em progresso` quando aberto e ainda não concluído.
- Exibir indicador visual nos temas já concluídos pelo estudante (`theme.completed_by?(Current.user)`).
- Substituir o avatar fixo `"A"` por link para `profile_path` com a inicial do `Current.user.full_name`.

### 3.3. Higiene e Remoção de Arquivos Órfãos
- Remover `patch_auth.rb` e `rename_to_admin.rb` da raiz.
- Remover `app/javascript/controllers/hello_controller.js` e `app/javascript/controllers/accordion_controller.js`.
