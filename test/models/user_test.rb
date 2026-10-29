require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save without required parameters" do
    user = User.new
    assert_not user.save, "Saved the user without required attributes"
    assert_includes user.errors[:full_name], "não pode ficar em branco"
    assert_includes user.errors[:age], "não pode ficar em branco"
  end

  test "should reject invalid education_level" do
    user = users(:student_one)
    assert_not user.update(education_level: "doutorado")
    assert user.errors[:education_level].present?
  end

  test "should save with all valid attributes" do
    user = User.new(
      email_address: "joao@example.com",
      password: "password123",
      full_name: "João Silva",
      age: 20,
      city: "São Paulo",
      education_level: :superior_incompleto
    )
    assert user.save, "Failed to save valid user"
  end

  test "block! should set blocked_at, destroy sessions and leaderboard" do
    user = users(:student_one)

    # Create a session
    user.user_sessions.create!(ip_address: "127.0.0.1", user_agent: "Test")

    # Has existing leaderboard from fixtures
    assert_not_nil user.leaderboard

    assert_not user.blocked?

    user.block!

    assert user.reload.blocked?
    assert_equal 0, user.user_sessions.count
    assert_nil user.leaderboard
  end

  test "unblock! should clear blocked_at" do
    user = users(:student_one)
    user.update(blocked_at: Time.current)
    assert user.blocked?

    user.unblock!

    assert_not user.blocked?
  end

  test "profile reports are optional and can be cleared with the current password" do
    user = users(:student_one)

    assert user.update_profile({ city: "", education_level: "" }, password: "password")
    assert_nil user.reload.city
    assert_nil user.education_level
  end

  test "profile changes require the current password and preserve persisted data on failure" do
    user = users(:student_one)
    original_email = user.email_address

    assert_not user.update_profile({ email_address: "changed@example.com" }, password: "wrong")
    assert user.errors[:current_password].present?
    assert_equal original_email, user.reload.email_address
  end

  test "erasure requires both the password and explicit confirmation" do
    user = users(:student_one)
    [ [ "wrong", "1" ], [ "password", "0" ], [ "", "1" ], [ "password", nil ] ].each do |password, confirmation|
      assert_no_difference [ "User.count", "ThemeAttempt.count", "QuestionSubmission.count", "UserSession.count", "Leaderboard.count" ] do
        assert_not user.erase_account(password: password, confirmed: confirmation)
      end
    end
  end

  test "erasure removes associated personal data and preserves other students and teaching content" do
    user = users(:student_one)
    user.user_sessions.create!
    user.user_sessions.create!
    attempt_ids = user.theme_attempts.pluck(:id)
    other_user = users(:student_two)
    other_attempt_ids = other_user.theme_attempts.pluck(:id)

    assert_no_difference [ "Question.count", "Option.count", "Theme.count", "Admin.count" ] do
      assert user.erase_account(password: "password", confirmed: "1")
    end

    assert_not User.exists?(user.id)
    assert_not UserSession.exists?(user_id: user.id)
    assert_not ThemeAttempt.exists?(user_id: user.id)
    assert_not QuestionSubmission.exists?(theme_attempt_id: attempt_ids)
    assert_not Leaderboard.exists?(user_id: user.id)
    assert_not LegalAcceptance.exists?(user_id: user.id)
    assert User.exists?(other_user.id)
    assert_equal other_attempt_ids, other_user.theme_attempts.pluck(:id)
    assert other_user.leaderboard.present?
  end
end
