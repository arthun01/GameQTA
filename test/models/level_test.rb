require "test_helper"

class LevelTest < ActiveSupport::TestCase
  test "should not save level without name" do
    level = Level.new(description: "Uma descrição legal")
    assert_not level.save, "Saved the level without a name"
  end

  test "should not save level without description" do
    level = Level.new(name: "Nível 1")
    assert_not level.save, "Saved the level without a description"
  end

  test "should save valid level" do
    level = Level.new(name: "Nível 1", description: "Uma descrição legal")
    assert level.save, "Failed to save the valid level"
  end

  test "should restrict deletion if themes are present" do
    level = levels(:one)
    Theme.create!(name: "Tema 1", description: "Desc", icon: "📚", level: level)

    assert_not level.destroy, "Destroyed the level with themes"
    assert_match(/não pode ser excluído porque possui (themes|temas) associados/, level.errors[:base].join)
  end

  test "starting_level? returns true only for the first level ordered by id" do
    first_level = Level.order(:id).first
    second_level = Level.order(:id).second

    assert first_level.starting_level?
    assert_not second_level.starting_level?
  end

  test "starting_level? shifts to the next oldest level if the first is deleted" do
    first_level = Level.order(:id).first
    second_level = Level.order(:id).second

    Question.where(theme: first_level.themes).destroy_all
    first_level.themes.destroy_all
    first_level.destroy

    assert second_level.starting_level?
  end

  test "unlocked_for? and completed_by? unlock next level when student reaches at least 70 percent across all themes" do
    user = users(:student_one)
    first_level = levels(:one)
    second_level = levels(:two)

    assert first_level.unlocked_for?(user)
    assert_not second_level.unlocked_for?(user)

    first_level.themes.each do |theme|
      ThemeAttempt.where(user: user, theme: theme).destroy_all
      attempt = ThemeAttempt.create!(user: user, theme: theme, status: :completed)
      theme.questions.each do |question|
        correct_option = question.options.find_by!(is_correct: true)
        QuestionSubmission.create!(
          theme_attempt: attempt,
          question: question,
          option: correct_option,
          is_correct: true,
          revealed_at: 10.seconds.ago,
          answered_at: Time.current,
          time_taken: 10
        )
      end
    end

    assert_equal 100.0, first_level.score_for(user)
    assert first_level.completed_by?(user)
    assert second_level.unlocked_for?(user)
  end

  test "score_for considers total questions in level and does not pass if themes are skipped" do
    user = users(:student_one)
    first_level = levels(:one)
    ThemeAttempt.where(user: user, theme: first_level.themes).destroy_all

    only_second_theme = themes(:two)
    attempt = ThemeAttempt.create!(user: user, theme: only_second_theme, status: :completed)
    question = only_second_theme.questions.first
    correct_option = question.options.find_by!(is_correct: true)
    QuestionSubmission.create!(
      theme_attempt: attempt,
      question: question,
      option: correct_option,
      is_correct: true,
      revealed_at: 10.seconds.ago,
      answered_at: Time.current,
      time_taken: 10
    )

    assert_operator first_level.score_for(user), :<, 70.0
    assert_not first_level.completed_by?(user)
    assert_not levels(:two).unlocked_for?(user)
  end
end
