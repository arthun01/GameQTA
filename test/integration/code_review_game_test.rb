require "test_helper"
require "csv"

class CodeReviewGameTest < ActionDispatch::IntegrationTest
  test "starting a locked level is refused by the server" do
    sign_in_as_user users(:student_one)
    assert_no_difference "ThemeAttempt.count" do
      post start_play_theme_path(themes(:three))
    end
    assert_redirected_to jornada_path
  end

  test "starting twice resumes the same attempt and keeps existing answers" do
    sign_in_as_user users(:student_one)
    attempt = theme_attempts(:one)
    submission_ids = attempt.question_submissions.ids
    2.times do
      assert_no_difference [ "ThemeAttempt.count", "QuestionSubmission.count" ] do
        post start_play_theme_path(themes(:one))
      end
      assert_redirected_to play_theme_attempt_question_path(attempt)
      assert_equal submission_ids, attempt.question_submissions.reload.ids
    end
  end

  test "empty teaching content never enters an automatic completion loop" do
    sign_in_as_user users(:student_one)
    theme = themes(:one)
    theme.questions.destroy_all

    assert_no_difference "ThemeAttempt.count" do
      post start_play_theme_path(theme)
    end
    assert_redirected_to jornada_path
    get play_theme_attempt_question_path(theme_attempts(:one))
    assert_redirected_to jornada_path
  end

  test "unanswered required questions remain in the denominator" do
    user = users(:student_one)
    question_submissions(:one).update!(is_correct: true)
    assert_in_delta 100.0 / 3, levels(:one).score_for(user), 0.1
    assert_not levels(:one).passed_by?(user)
  end

  test "all themes must be completed to unlock the next level and GET cannot complete a theme" do
    user = users(:student_one)
    sign_in_as_user user
    attempt = theme_attempts(:one)
    get finish_play_theme_path(themes(:one))
    assert attempt.reload.in_progress?
    assert_not levels(:two).available_to?(user)

    complete_answers(attempt)
    post play_theme_completion_path(themes(:one)), params: { attempt_id: attempt.id }
    assert_redirected_to jornada_path
    assert_not levels(:two).available_to?(user)

    second = user.theme_attempts.create!(theme: themes(:two))
    complete_answers(second)
    post play_theme_completion_path(themes(:two)), params: { attempt_id: second.id }
    assert levels(:two).available_to?(user)
    get jornada_path
    assert_select "details summary h2", text: levels(:two).name
    post start_play_theme_path(themes(:three))
    assert_redirected_to play_theme_attempt_question_path(ThemeAttempt.order(:id).last)
  end

  test "completion refuses unrevealed and revealed unanswered questions" do
    user = users(:student_one)
    sign_in_as_user user
    attempt = theme_attempts(:one)
    [ false, true ].each do |reveal|
      attempt.reveal_question(time_multiplier: 1) if reveal
      assert_no_difference "ThemeAttempt.count" do
        post play_theme_completion_path(themes(:one)), params: { attempt_id: attempt.id }
      end
      assert_redirected_to play_theme_attempt_question_path(attempt)
      assert attempt.reload.in_progress?
    end
  end

  test "reset recalculates ranking after removal without recreating erased users" do
    user = users(:student_one)
    user.update_leaderboard
    assert user.leaderboard
    perform_enqueued_jobs do
      levels(:one).reset_progress_for(user)
    end
    assert_equal 0, user.leaderboard.reload.total_score
    assert_equal 0, user.leaderboard.total_time_taken
  end

  test "a failed completed level is reset once and repeated completion preserves the result" do
    user = users(:student_one)
    sign_in_as_user user
    first = theme_attempts(:one)
    second = user.theme_attempts.create!(theme: themes(:two))
    [ first, second ].each do |attempt|
      complete_answers(attempt)
      attempt.question_submissions.update_all(is_correct: false)
    end

    post play_theme_completion_path(themes(:one)), params: { attempt_id: first.id }
    post play_theme_completion_path(themes(:two)), params: { attempt_id: second.id }
    assert_redirected_to finish_play_theme_path(themes(:two))
    assert_not ThemeAttempt.where(user: user).exists?
    get finish_play_theme_path(themes(:two))
    assert_select "h1", text: "Nível Reprovado!"

    assert_no_difference [ "ThemeAttempt.count", "QuestionSubmission.count" ] do
      post play_theme_completion_path(themes(:two)), params: { attempt_id: second.id }
    end
    assert_redirected_to finish_play_theme_path(themes(:two))
    get finish_play_theme_path(themes(:two))
    assert_select "h1", text: "Nível Reprovado!"
  end

  test "deleting teaching answers also schedules a ranking refresh" do
    assert_enqueued_with(job: Leaderboards::UpdateUserJob, args: [ users(:student_one).id ]) do
      question_submissions(:one).destroy!
    end
  end

  test "theme metrics distinguish attempts and answered questions" do
    sign_in_as admins(:one)
    theme = themes(:one)
    attempt = theme_attempts(:one)
    attempt.question_submissions.create!(question: questions(:three), revealed_at: Time.current, answered_at: Time.current, is_correct: true)
    get themes_admin_reports_path
    row = CSV.parse(response.body, headers: true).find { |record| record["ID"] == theme.id.to_s }
    assert_equal "1", row["Total_Tentativas"]
    assert_equal "2", row["Total_Respostas"]
    assert_equal "1", row["Total_Acertos"]
    assert_equal "50.0%", row["Taxa_Acertos"]
    get admin_root_path
    assert_select "dt", text: "Temas Concluídos" do |labels|
      assert_equal ThemeAttempt.completed.count.to_s, labels.first.parent.at_css("dd").text.strip
    end
  end

  test "a tied participant outside the ten rows still sees their true position" do
    Leaderboard.delete_all
    other_users = (1..10).map do |number|
      User.create!(full_name: "Participante #{number}", email_address: "tie#{number}@example.com", password: "password")
    end
    # Keep the current participant outside the deterministic ten-row cutoff.
    others = other_users.sort_by(&:id)
    others.each { |other| other.create_leaderboard!(total_score: 100, total_time_taken: 10) }
    user = User.create!(full_name: "Participante atual", email_address: "current-tie@example.com", password: "password")
    user.accept_legal_documents(accepted: true, revision: LegalDocument.revision)
    user.create_leaderboard!(total_score: 100, total_time_taken: 10)
    sign_in_as_user user
    get ranking_path
    assert_response :success
    assert_select "[data-personal-ranking]", text: /Sua Posição/i
    assert_select "[data-personal-ranking] [data-ranking-position]", text: "1"
  end

  private
    def complete_answers(attempt)
      attempt.theme.questions.each do |question|
        answer = attempt.question_submissions.find_or_initialize_by(question: question)
        answer.assign_attributes(revealed_at: Time.current, answered_at: Time.current, is_correct: true,
          option: question.options.find_by!(is_correct: true), time_taken: 1)
        answer.save!
      end
    end
end
