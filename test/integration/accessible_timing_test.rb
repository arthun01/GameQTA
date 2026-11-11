require "test_helper"

class AccessibleTimingTest < ActionDispatch::IntegrationTest
  setup do
    @attempt = theme_attempts(:one)
    @question = questions(:three)
    sign_in_as_user users(:student_one)
  end

  test "a stale answer cannot close another revealed question" do
    post reveal_play_theme_attempt_question_path(@attempt), as: :turbo_stream
    pending = @attempt.question_submissions.find_by!(question: @question)
    post submit_play_theme_attempt_question_path(@attempt), params: { submission_id: question_submissions(:one).id }, as: :turbo_stream
    assert_redirected_to play_theme_attempt_question_path(@attempt)
    assert_nil pending.reload.answered_at
    assert_select "dialog", count: 0
  end

  test "time choice is recorded once and reload cannot reset it" do
    patch profile_time_preference_path, params: { user: { response_time_multiplier: "10" } }
    assert_redirected_to profile_path
    post reveal_play_theme_attempt_question_path(@attempt), params: { time_multiplier: "1" }, as: :turbo_stream
    submission = @attempt.question_submissions.find_by!(question: @question)
    assert_equal GameSetting.current.easy_time * 10, submission.time_limit_seconds
    deadline = submission.revealed_at
    travel 45.seconds do
      get play_theme_attempt_question_path(@attempt)
      assert_select "[data-gameplay-timer-seconds-value]" do |elements|
        assert_operator elements.first["data-gameplay-timer-seconds-value"].to_i, :<=, submission.allowed_seconds - 44
      end
      patch profile_time_preference_path, params: { user: { response_time_multiplier: "1" } }
      post reveal_play_theme_attempt_question_path(@attempt), params: { time_multiplier: "1" }, as: :turbo_stream
    end
    assert_equal deadline, submission.reload.revealed_at
    assert_equal GameSetting.current.easy_time * 10, submission.time_limit_seconds
  end

  test "saved preference applies automatically to subsequent questions after logging in again" do
    patch profile_time_preference_path, params: { user: { response_time_multiplier: "3" } }
    delete sair_path
    post entrar_path, params: { email_address: users(:student_one).email_address, password: "password" }
    post reveal_play_theme_attempt_question_path(@attempt), as: :turbo_stream
    assert_equal GameSetting.current.easy_time * 3, @attempt.question_submissions.find_by!(question: @question).allowed_seconds

    post start_play_theme_path(themes(:two))
    second = users(:student_one).theme_attempts.find_by!(theme: themes(:two))
    post reveal_play_theme_attempt_question_path(second), as: :turbo_stream
    assert_equal GameSetting.current.medium_time * 3, second.question_submissions.sole.allowed_seconds
  end

  test "gameplay has no time selection and uses the default without any setup" do
    get play_theme_attempt_question_path(@attempt)
    assert_select "select", count: 0
    assert_select "form[action=?] input[name=time_multiplier]", reveal_play_theme_attempt_question_path(@attempt), count: 0
    post reveal_play_theme_attempt_question_path(@attempt), params: { time_multiplier: "10" }, as: :turbo_stream
    assert_equal GameSetting.current.easy_time, @attempt.question_submissions.find_by!(question: @question).allowed_seconds
  end

  test "timeout is final and advances instead of reopening the same question" do
    post reveal_play_theme_attempt_question_path(@attempt), params: { time_multiplier: "1000" }, as: :turbo_stream
    submission = @attempt.question_submissions.find_by!(question: @question)
    assert_equal GameSetting.current.easy_time, submission.allowed_seconds
    travel (submission.allowed_seconds + 3).seconds do
      post submit_play_theme_attempt_question_path(@attempt), params: { submission_id: submission.id, option_id: @question.options.first.id }, as: :turbo_stream
    end
    assert_response :success
    assert submission.reload.answered_at
    assert_not submission.is_correct?
    assert_nil @attempt.next_pending_question
    answered_at = submission.answered_at
    post submit_play_theme_attempt_question_path(@attempt), params: { submission_id: submission.id }, as: :turbo_stream
    assert_equal answered_at, submission.reload.answered_at
  end
end
