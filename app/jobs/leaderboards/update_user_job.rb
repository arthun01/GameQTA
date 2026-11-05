class Leaderboards::UpdateUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    User.find_by(id: user_id)&.update_leaderboard
  rescue ActiveRecord::RecordNotFound
    # A conta pode ser excluída entre a consulta e a aquisição do lock.
  end
end
