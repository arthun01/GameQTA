class ThemeAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :theme
  has_many :question_submissions, dependent: :destroy

  enum :status, { in_progress: 0, completed: 1 }

  validates :status, presence: true
  validates :theme_id, uniqueness: { scope: :user_id, conditions: -> { in_progress } }

  def next_pending_question
    # Encontra questoes do tema que ainda não tem submission nesta tentativa
    answered_question_ids = question_submissions.select(:question_id)
    theme.questions.where.not(id: answered_question_ids).order(:id).first
  end
end
