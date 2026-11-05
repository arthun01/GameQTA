class RankingsController < Users::BaseController
  def index
    @top_leaderboards = Leaderboard.ranked.includes(:user).limit(10).to_a
    @current_user_leaderboard = Leaderboard.ranking_for(Current.user)
    @current_user_position = @current_user_leaderboard&.position
    @show_personal_ranking = @current_user_leaderboard.present? &&
      @top_leaderboards.none? { |leaderboard| leaderboard.user_id == Current.user.id }
  end
end
