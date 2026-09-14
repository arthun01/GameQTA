class Level < ApplicationRecord
  has_many :themes, dependent: :restrict_with_error

  validates :name, presence: true
  validates :description, presence: true

  def starting_level?
    self == Level.order(:id).first
  end
end
