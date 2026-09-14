class Users::SessionsController < Users::BaseController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to "/entrar", alert: t(".rate_limit") }

  def new
  end

  def create
    if user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to "/entrar", alert: t(".invalid_credentials")
    end
  end

  def destroy
    terminate_session
    redirect_to "/entrar"
  end
end
