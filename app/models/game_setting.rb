class GameSetting < ApplicationRecord
  validates :easy_time, :medium_time, :hard_time, presence: true, numericality: { greater_than: 0 }
end
