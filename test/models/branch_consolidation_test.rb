require "test_helper"

class BranchConsolidationModelTest < ActiveSupport::TestCase
  test "a displayed rounded score of 70 percent does not approve an actual result below 70" do
    level = Level.create!(name: "Precisão", description: "Limite de aprovação")
    theme = level.themes.create!(name: "Tema", description: "Descrição", icon: "🌱")
    Question.insert_all!(2000.times.map do |index|
      { theme_id: theme.id, statement: "Questão #{index}", difficulty: 0,
        youtube_link: "https://youtu.be/example", feedback_article: "Feedback" }
    end)
    user = users(:student_one)
    attempt = user.theme_attempts.create!(theme: theme, status: :completed)
    QuestionSubmission.insert_all!(theme.questions.ids.each_with_index.map do |id, index|
      { theme_attempt_id: attempt.id, question_id: id, revealed_at: Time.current,
        answered_at: Time.current, is_correct: index < 1399 }
    end)

    assert_equal 70.0, level.score_for(user)
    assert_not level.passed_by?(user)
    attempt.question_submissions.where(is_correct: false).first.update!(is_correct: true)
    assert level.passed_by?(user)
  end

  test "progress lookup loads at most one attempt per theme even with a long history" do
    user = users(:student_one)
    theme = themes(:one)
    ThemeAttempt.insert_all!(500.times.map do |index|
      { user_id: user.id, theme_id: theme.id, status: ThemeAttempt.statuses.fetch("completed"),
        created_at: (index + 1).days.ago, updated_at: Time.current }
    end)
    instantiated = 0
    subscriber = ->(_name, _start, _finish, _id, payload) do
      instantiated += payload[:record_count] if payload[:class_name] == "ThemeAttempt"
    end
    ActiveSupport::Notifications.subscribed(subscriber, "instantiation.active_record") do
      levels(:one).score_for(user)
    end
    assert_operator instantiated, :<=, levels(:one).themes.count
  end

  test "correct answers persist points for each difficulty and wrong or timed out answers score zero" do
    question = questions(:one)
    theme = question.theme
    user = users(:student_two)
    %w[easy medium hard].zip([ 10, 20, 30 ]).each do |difficulty, points|
      question.update!(difficulty: difficulty)
      attempt = user.theme_attempts.create!(theme: theme, status: :completed)
      answer = attempt.question_submissions.create!(question: question, revealed_at: Time.current)
      assert answer.answer(option_id: question.options.find_by!(is_correct: true).id)
      assert_equal points, answer.reload.score
    end

    [ false, true ].each do |timeout|
      attempt = user.theme_attempts.create!(theme: theme, status: :completed)
      answer = attempt.question_submissions.create!(question: question, revealed_at: timeout ? 10.minutes.ago : Time.current)
      option = question.options.find_by!(is_correct: timeout)
      assert answer.answer(option_id: option.id)
      assert_equal 0, answer.reload.score
    end
  end
end
