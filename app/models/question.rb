class Question < ApplicationRecord
  belongs_to :theme
  has_many :options, dependent: :destroy
  has_many :question_submissions, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true

  enum :difficulty, { easy: 0, medium: 1, hard: 2 }

  validates :statement, :youtube_link, :feedback_article, :difficulty, presence: true
  validates :youtube_link, format: {
    with: %r{\A(https?://)?(www\.)?(youtube\.com|youtu\.be)/.+\z}i,
    message: :invalid_youtube_link
  }

  validate :validate_options_count_and_correctness

  def youtube_video_id
    return nil if youtube_link.blank?
    if match = youtube_link.match(%r{(?:v=|youtu\.be/|embed/)([^&?]+)})
      match[1]
    end
  end

  private

  def validate_options_count_and_correctness
    active_options = options.reject(&:marked_for_destruction?)

    errors.add(:options, :invalid_count) unless active_options.size.between?(2, 5)
    errors.add(:options, :must_have_exactly_one_correct) if active_options.count(&:is_correct) != 1
  end
end
