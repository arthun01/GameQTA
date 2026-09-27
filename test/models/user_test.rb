require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save without required parameters" do
    user = User.new
    assert_not user.save, "Saved the user without required attributes"
    assert_includes user.errors[:full_name], "não pode ficar em branco"
    assert_includes user.errors[:age], "não pode ficar em branco"
    assert_includes user.errors[:city], "não pode ficar em branco"
    assert_includes user.errors[:education_level], "não pode ficar em branco"
  end

  test "should reject invalid education_level" do
    assert_raises(ArgumentError) do
      User.new(education_level: "doutorado")
    end
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
end
