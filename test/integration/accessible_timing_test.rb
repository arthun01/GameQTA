require "test_helper"

class AccessibleTimingTest < ActionDispatch::IntegrationTest
  setup do
    @attempt = theme_attempts(:one)
    @question = questions(:three)
    sign_in_as_user users(:student_one)
  end

  test "time choice is recorded once and reload cannot reset it" do
    post reveal_play_theme_attempt_question_path(@attempt), params: { time_multiplier: "10" }, as: :turbo_stream
    submission = @attempt.question_submissions.find_by!(question: @question)
    assert_equal GameSetting.current.easy_time * 10, submission.time_limit_seconds
    deadline = submission.revealed_at
    travel 45.seconds do
      get play_theme_attempt_question_path(@attempt)
      assert_select "[data-gameplay-timer-seconds-value]" do |elements|
        assert_operator elements.first["data-gameplay-timer-seconds-value"].to_i, :<=, submission.allowed_seconds - 44
      end
      post reveal_play_theme_attempt_question_path(@attempt), params: { time_multiplier: "1" }, as: :turbo_stream
    end
    assert_equal deadline, submission.reload.revealed_at
    assert_equal GameSetting.current.easy_time * 10, submission.time_limit_seconds
  end

  test "timeout is final and advances instead of reopening the same question" do
    post reveal_play_theme_attempt_question_path(@attempt), params: { time_multiplier: "1000" }, as: :turbo_stream
    submission = @attempt.question_submissions.find_by!(question: @question)
    assert_equal GameSetting.current.easy_time, submission.allowed_seconds
    travel (submission.allowed_seconds + 3).seconds do
      post submit_play_theme_attempt_question_path(@attempt), params: { option_id: @question.options.first.id }, as: :turbo_stream
    end
    assert_response :success
    assert submission.reload.answered_at
    assert_not submission.is_correct?
    assert_nil @attempt.next_pending_question
    answered_at = submission.answered_at
    post submit_play_theme_attempt_question_path(@attempt), as: :turbo_stream
    assert_equal answered_at, submission.reload.answered_at
  end
end
