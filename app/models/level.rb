class Level < ApplicationRecord
  has_many :themes, dependent: :restrict_with_error

  validates :name, presence: true
  validates :description, presence: true
end
