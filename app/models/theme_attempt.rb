class ThemeAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :theme
  has_many :question_submissions, dependent: :destroy

  enum :status, { in_progress: 0, completed: 1 }

  validates :status, presence: true
  validates :theme_id, uniqueness: { scope: :user_id, conditions: -> { in_progress } }

  def next_pending_question
    # Se existe uma submission pendente (foi revelada mas option_id é nil), retorna a questão dela
    pending_sub = question_submissions.find_by(answered_at: nil, option_id: nil)
    return pending_sub.question if pending_sub

    # Caso contrário, pega a próxima questão que ainda não foi respondida
    answered_question_ids = question_submissions.where.not(answered_at: nil).or(question_submissions.where.not(option_id: nil)).select(:question_id)
    theme.questions.where.not(id: answered_question_ids).order(:id).first
  end

  def reveal_question(time_multiplier:)
    with_lock do
      question = next_pending_question
      if question.present?
        question_submissions.find_or_create_by!(question: question) do |submission|
          chosen_multiplier = Integer(time_multiplier, exception: false)
          multiplier = (1..10).include?(chosen_multiplier) ? chosen_multiplier : 1
          submission.revealed_at = Time.current
          submission.time_limit_seconds = GameSetting.current.time_for_difficulty(question.difficulty) * multiplier
        end
      end
    end
  end
end
