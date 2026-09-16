require "test_helper"

class Play::ThemesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = users(:student_one)
    @theme = themes(:one)
    post entrar_url, params: { email_address: @student.email_address, password: "password" }
  end

  test "should start theme attempt and redirect to pending question" do
    assert_difference("ThemeAttempt.count", 1) do
      post start_play_theme_url(themes(:two))
    end

    attempt = ThemeAttempt.last
    assert attempt.in_progress?
    assert_redirected_to play_theme_attempt_question_url(attempt)
  end

  test "starting theme should clear previous in_progress attempt for same theme" do
    assert_no_difference("ThemeAttempt.count") do
      post start_play_theme_url(@theme)
    end

    attempt = ThemeAttempt.last
    assert_redirected_to play_theme_attempt_question_url(attempt)
  end

  test "cannot start if not logged in" do
    delete sair_url
    post start_play_theme_url(@theme)
    assert_redirected_to entrar_url
  end
end
