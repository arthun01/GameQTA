class Theme < ApplicationRecord
  belongs_to :level

  validates :name, :description, :icon, presence: true
end
