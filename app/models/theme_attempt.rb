class ThemeAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :theme
  has_many :question_submissions, dependent: :destroy

  enum :status, { in_progress: 0, completed: 1 }

  validates :status, presence: true
  validates :theme_id, uniqueness: { scope: :user_id, conditions: -> { in_progress } }
end
