class RankingsController < Users::BaseController
  def index
    @top_leaderboards = Leaderboard.includes(:user)
                                   .order(total_score: :desc, total_time_taken: :asc)
                                   .limit(10)

    if Current.user
      sql = <<-SQL
        SELECT r.position#{' '}
        FROM (
          SELECT user_id, DENSE_RANK() OVER (ORDER BY total_score DESC, total_time_taken ASC) as position#{' '}
          FROM leaderboards
        ) as r
        WHERE r.user_id = :user_id
      SQL

      result = Leaderboard.connection.select_one(
        Leaderboard.sanitize_sql_array([ sql, user_id: Current.user.id ])
      )

      @current_user_position = result ? result["position"].to_i : nil
      @current_user_leaderboard = Current.user.leaderboard
    end
  end
end
