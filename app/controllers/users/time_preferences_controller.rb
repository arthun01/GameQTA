class Users::TimePreferencesController < Users::BaseController
  skip_before_action :require_current_legal_acceptance

  def update
    @user = Current.user
    if @user.update(time_preference_params)
      redirect_to profile_path, notice: t(".success"), status: :see_other
    else
      render "users/profiles/show", status: :unprocessable_entity
    end
  end

  private
    def time_preference_params
      params.expect(user: [ :response_time_multiplier ])
    end
end
