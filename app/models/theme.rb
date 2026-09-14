class Theme < ApplicationRecord
  belongs_to :level
  has_many :questions, dependent: :restrict_with_error

  validates :name, :description, :icon, presence: true
end
