class Users::ProfilesController < Users::BaseController
  skip_before_action :require_current_legal_acceptance
  before_action :set_user
  rate_limit to: 10, within: 3.minutes, only: %i[ update destroy ], with: -> { redirect_to profile_path, alert: t("users.profiles.rate_limit") }

  def show
    response.headers["Cache-Control"] = "no-store"
  end

  def edit
    response.headers["Cache-Control"] = "no-store"
  end

  def update
    if @user.update_profile(profile_params, password: params.dig(:user, :current_password))
      redirect_to profile_path, notice: t(".success"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.erase_account(password: params.dig(:user, :current_password), confirmed: params.dig(:user, :deletion_confirmed))
      cookies.delete(:user_session_id)
      Current.user_session = nil
      reset_session
      redirect_to entrar_path, notice: t(".success"), status: :see_other
    else
      render :show, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = Current.user
      response.headers["Cache-Control"] = "no-store"
    end

    def profile_params
      params.expect(user: [ :full_name, :email_address, :age, :city, :education_level ])
    end
end
