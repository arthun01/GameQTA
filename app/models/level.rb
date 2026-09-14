class Level < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
end
