class QuestionSubmission < ApplicationRecord
  belongs_to :theme_attempt
  belongs_to :question
  belongs_to :option, optional: true

  validates :revealed_at, presence: true
  validates :question_id, uniqueness: { scope: :theme_attempt_id }
end
