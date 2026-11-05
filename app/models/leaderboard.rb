class Leaderboard < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :total_score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_time_taken, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ranked, -> {
    select("leaderboards.*, DENSE_RANK() OVER (ORDER BY total_score DESC, total_time_taken ASC) AS position")
      .order(total_score: :desc, total_time_taken: :asc, user_id: :asc)
  }

  def self.ranking_for(user)
    from(ranked.reorder(nil), :leaderboards).find_by(user_id: user.id)
  end
end
