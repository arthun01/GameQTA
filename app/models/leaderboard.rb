class Leaderboard < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :total_score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_time_taken, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
