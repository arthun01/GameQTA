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
end
