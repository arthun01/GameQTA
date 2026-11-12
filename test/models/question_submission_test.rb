require "test_helper"

class QuestionSubmissionTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

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

  test "enqueues UpdateUserJob after creation" do
    assert_enqueued_with(job: Leaderboards::UpdateUserJob) do
      QuestionSubmission.create!(
        theme_attempt: theme_attempts(:two),
        question: questions(:one),
        revealed_at: Time.current
      )
    end
  end

  test "answer persists earned score and enqueues UpdateUserJob on destroy" do
    submission = QuestionSubmission.create!(
      theme_attempt: theme_attempts(:two),
      question: questions(:one),
      revealed_at: Time.current
    )
    correct_option = questions(:one).options.find_by!(is_correct: true)
    submission.answer(option_id: correct_option.id)

    assert submission.reload.is_correct?
    assert_equal 10, submission.score

    assert_enqueued_with(job: Leaderboards::UpdateUserJob) do
      submission.destroy!
    end
  end
end
