require "test_helper"

class QuestionSubmissionTest < ActiveSupport::TestCase
  setup do
    @attempt = theme_attempts(:one)
    @question = questions(:one)
  end

  test "validates uniqueness of question within theme_attempt" do
    submission2 = QuestionSubmission.new(theme_attempt: @attempt, question: @question, revealed_at: Time.current)

    assert_not submission2.valid?
    assert_includes submission2.errors.map(&:type), :taken
  end

  test "option can be null for timeout" do
    # use question: one for attempt: two, since there is no submission for this pair
    submission = QuestionSubmission.new(theme_attempt: theme_attempts(:two), question: questions(:one), revealed_at: Time.current)
    assert submission.valid?, submission.errors.full_messages.join(", ")
  end
end
