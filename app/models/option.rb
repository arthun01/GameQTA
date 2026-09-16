class Option < ApplicationRecord
  belongs_to :question
  has_many :question_submissions, dependent: :nullify

  validates :content, presence: true
  validates :is_correct, inclusion: { in: [ true, false ] }
end
