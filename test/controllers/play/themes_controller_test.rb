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

  test "starting theme should resume previous in_progress attempt for same theme" do
    assert_no_difference("ThemeAttempt.count") do
      post start_play_theme_url(@theme)
    end

    assert_redirected_to play_theme_attempt_question_url(theme_attempts(:one))
  end

  test "cannot start if not logged in" do
    delete sair_url
    post start_play_theme_url(@theme)
    assert_redirected_to entrar_url
  end

  test "cannot start a theme from a locked level" do
    locked_theme = themes(:three)
    assert_no_difference("ThemeAttempt.count") do
      post start_play_theme_url(locked_theme)
    end
    assert_redirected_to jornada_url
  end

  test "cannot finish a theme while questions are still pending" do
    attempt = theme_attempts(:one)
    post play_theme_completion_path(attempt.theme), params: { attempt_id: attempt.id }
    assert_redirected_to play_theme_attempt_question_url(attempt)
    assert attempt.reload.in_progress?
  end
end
