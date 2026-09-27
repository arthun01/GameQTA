require "test_helper"

class LeaderboardTest < ActiveSupport::TestCase
  test "validates uniqueness of user_id" do
    existing_leaderboard = leaderboards(:student_one_leaderboard)
    new_leaderboard = Leaderboard.new(
      user: existing_leaderboard.user,
      total_score: 10,
      total_time_taken: 10
    )

    assert_not new_leaderboard.valid?
    assert_includes new_leaderboard.errors[:user_id], "já está em uso" # Assuming i18n translates 'has already been taken' to pt-BR if it's default
  end

  test "validates total_score is greater than or equal to 0" do
    leaderboard = Leaderboard.new(user: users(:student_one), total_score: -10, total_time_taken: 10)
    assert_not leaderboard.valid?
  end

  test "validates total_time_taken is greater than or equal to 0" do
    leaderboard = Leaderboard.new(user: users(:student_one), total_score: 10, total_time_taken: -10)
    assert_not leaderboard.valid?
  end

  test "belongs to user" do
    assert_instance_of User, leaderboards(:student_one_leaderboard).user
  end
end
