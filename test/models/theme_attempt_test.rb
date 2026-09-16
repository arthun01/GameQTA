require "test_helper"

class ThemeAttemptTest < ActiveSupport::TestCase
  test "status default is in_progress" do
    attempt = ThemeAttempt.new(user: users(:student_one), theme: themes(:two))
    assert attempt.in_progress?
  end

  test "cannot have two in_progress attempts for same user and theme" do
    attempt2 = ThemeAttempt.new(user: users(:student_one), theme: themes(:one))

    assert_not attempt2.valid?
    assert_includes attempt2.errors.map(&:type), :taken
  end

  test "can have completed attempt and new in_progress attempt" do
    attempt2 = ThemeAttempt.new(user: users(:student_two), theme: themes(:two))

    assert attempt2.valid?
  end

  test "next_pending_question returns the first unanswered question" do
    attempt = theme_attempts(:one)
    assert_equal questions(:three), attempt.next_pending_question
  end

  test "next_pending_question returns nil if all answered" do
    attempt = theme_attempts(:two)
    assert_nil attempt.next_pending_question
  end
end
