class ThemeAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :theme
  has_many :question_submissions, dependent: :destroy

  enum :status, { in_progress: 0, completed: 1 }

  validates :status, presence: true
  validates :theme_id, uniqueness: { scope: :user_id, conditions: -> { in_progress } }

  def next_pending_question
    # Se existe uma submission pendente (foi revelada mas option_id é nil), retorna a questão dela
    pending_sub = question_submissions.find_by(option_id: nil)
    return pending_sub.question if pending_sub

    # Caso contrário, pega a próxima questão que ainda não foi respondida
    answered_question_ids = question_submissions.where.not(option_id: nil).select(:question_id)
    theme.questions.where.not(id: answered_question_ids).order(:id).first
  end
end
