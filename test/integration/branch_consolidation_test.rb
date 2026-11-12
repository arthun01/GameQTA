require "test_helper"

class BranchConsolidationTest < ActionDispatch::IntegrationTest
  test "student and admin login preserve independent return destinations" do
    get profile_path
    assert_redirected_to entrar_path
    get admin_reports_path
    assert_redirected_to new_admin_session_path

    post entrar_path, params: { email_address: users(:student_one).email_address, password: "password" }
    assert_redirected_to profile_path
    post admin_session_path, params: { email_address: admins(:one).email_address, password: "password" }
    assert_redirected_to admin_reports_path
  end

  test "admin login after visiting a student page returns to the admin dashboard" do
    get profile_path
    post admin_session_path, params: { email_address: admins(:one).email_address, password: "password" }
    assert_redirected_to admin_root_path
    follow_redirect!
    assert_response :success
  end

  test "student login after visiting an admin page returns to the journey" do
    get admin_reports_path
    post entrar_path, params: { email_address: users(:student_one).email_address, password: "password" }
    assert_redirected_to jornada_path
  end

  test "unblocking restores the ranking from preserved answers immediately" do
    user = users(:student_two)
    user.update_leaderboard
    points = user.leaderboard.reload.total_score
    answers = user.theme_attempts.joins(:question_submissions).count
    assert_operator points, :>, 0
    user.block!
    user.unblock!

    assert_not user.reload.blocked?
    assert_equal answers, user.theme_attempts.joins(:question_submissions).count
    assert_equal points, user.leaderboard&.total_score
    assert_equal points, user.total_score
    assert Leaderboard.ranking_for(user)
  end

  test "journey images follow curriculum order and avatar links to the profile" do
    first = Level.create!(id: -20, name: "Primeiro nível", description: "Descrição")
    second = Level.create!(id: -10, name: "Segundo nível", description: "Descrição")
    sign_in_as_user users(:student_one)
    get jornada_path

    assert_select "a[href=?][aria-label=?]", profile_path, I18n.t("accessibility.profile_link"), text: users(:student_one).full_name.first.upcase
    assert_select "img[alt=?][src='/ods-1.png']", first.name
    assert_select "img[alt=?][src='/ods-2.png']", second.name
    assert_select "title", text: I18n.t("dashboard.index.title")
  end

  test "replaying a passed theme keeps downstream levels available" do
    user = users(:student_one)
    levels(:one).themes.each do |theme|
      attempt = user.theme_attempts.find_or_create_by!(theme: theme, status: :in_progress)
      theme.questions.each do |question|
        submission = attempt.question_submissions.find_or_initialize_by(question: question)
        submission.update!(revealed_at: Time.current, answered_at: Time.current,
          option: question.options.find_by!(is_correct: true), is_correct: true)
      end
      attempt.update!(status: :completed)
    end
    assert levels(:two).available_to?(user)
    replay = user.start_theme(themes(:one))
    assert levels(:two).available_to?(user)

    sign_in_as_user user
    get jornada_path
    assert_select "details summary", text: /Concluído.*100[.,]0%/m
    assert_select "details li span", text: /Concluído/
    assert_select "details summary h2", text: levels(:two).name

    replay.theme.questions.each do |question|
      replay.question_submissions.create!(question: question, revealed_at: Time.current,
        answered_at: Time.current, is_correct: false)
    end
    result = replay.complete
    assert result.fetch("level_finished")
    assert_equal false, result.fetch("passed")
    assert_not ThemeAttempt.where(user: user, theme: levels(:one).themes).exists?
    assert_not levels(:two).available_to?(user)
  end
end
