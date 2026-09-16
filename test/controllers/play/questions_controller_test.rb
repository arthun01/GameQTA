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
    # student_two has an attempt for theme two, which only has question two.
    # The fixture already marks it as answered.
    attempt = theme_attempts(:two)

    post entrar_url, params: { email_address: users(:student_two).email_address, password: "password" }

    get play_theme_attempt_question_url(attempt)
    assert_redirected_to jornada_url
  end
end
