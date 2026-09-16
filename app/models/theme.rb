class Theme < ApplicationRecord
  belongs_to :level
  has_many :questions, dependent: :restrict_with_error
  has_many :theme_attempts, dependent: :destroy

  validates :name, :description, :icon, presence: true
end
