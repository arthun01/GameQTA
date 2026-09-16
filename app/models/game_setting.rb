class GameSetting < ApplicationRecord
  validates :easy_time, :medium_time, :hard_time, presence: true, numericality: { greater_than: 0 }

  def self.current
    first || create!(easy_time: 60, medium_time: 45, hard_time: 30)
  end

  def time_for_difficulty(difficulty)
    case difficulty.to_s
    when "easy" then easy_time
    when "medium" then medium_time
    when "hard" then hard_time
    else easy_time
    end
  end
end
