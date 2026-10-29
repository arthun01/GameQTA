require "test_helper"

class Leaderboards::UpdateUserJobTest < ActiveJob::TestCase
  test "calculates score and time correctly and upserts leaderboard" do
    user = users(:student_one)

    # Executar o Job
    Leaderboards::UpdateUserJob.perform_now(user.id)

    leaderboard = user.leaderboard

    # Verificar cálculo:
    # student_one tem uma submissões:
    # 1 errada (15s)
    # Total esperado: Score 0, Tempo 15
    assert_equal 0, leaderboard.total_score
    assert_equal 15, leaderboard.total_time_taken
  end

  test "calculates medium difficulty score" do
    user = users(:student_two)

    # Executar o Job
    Leaderboards::UpdateUserJob.perform_now(user.id)

    leaderboard = user.leaderboard

    # student_two tem:
    # 1 correta (médio -> 20 pts, 20s)
    assert_equal 20, leaderboard.total_score
    assert_equal 20, leaderboard.total_time_taken
  end

  test "pending updates do not recreate the leaderboard of an erased account" do
    user = users(:student_one)
    user.erase_account(password: "password", confirmed: "1")

    assert_no_difference "Leaderboard.count" do
      Leaderboards::UpdateUserJob.perform_now(user.id)
    end
    assert_not Leaderboard.exists?(user_id: user.id)
  end

  test "pending updates do not put blocked students back in the ranking" do
    user = users(:student_one)
    user.block!

    assert_no_difference "Leaderboard.count" do
      Leaderboards::UpdateUserJob.perform_now(user.id)
    end
    assert_not Leaderboard.exists?(user_id: user.id)
  end
end
