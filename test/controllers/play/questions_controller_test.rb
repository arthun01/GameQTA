require "test_helper"

class Play::QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = users(:student_one)
    @attempt = theme_attempts(:one)
    post entrar_url, params: { email_address: @student.email_address, password: "password" }
  end

  test "should get show for own attempt" do
    get play_theme_attempt_question_url(@attempt)
    assert_response :success
    assert_select "iframe" # check video present
    assert_select "button", text: "Mostrar Questão"
  end

  test "should not get show for other user attempt" do
    @other_attempt = theme_attempts(:two)
    get play_theme_attempt_question_url(@other_attempt)
    assert_redirected_to jornada_url
  end

  test "should redirect to dashboard if no questions left" do
    attempt = theme_attempts(:two)
    post entrar_url, params: { email_address: users(:student_two).email_address, password: "password" }

    get play_theme_attempt_question_url(attempt)
    assert_redirected_to finish_play_theme_url(attempt.theme)
  end

  test "should post reveal and create a provisional submission" do
    assert_difference("QuestionSubmission.count", 1) do
      post reveal_play_theme_attempt_question_url(@attempt), as: :turbo_stream
    end

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", @response.media_type
    assert_select "turbo-stream[action='update'][target='question_play_area']"

    submission = QuestionSubmission.last
    assert_not_nil submission.revealed_at
    assert_equal questions(:three), submission.question
  end
end
