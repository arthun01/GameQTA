class Admin::PasswordsController < Admin::BaseController
  allow_unauthenticated_access
  before_action :set_admin_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if admin = ::Admin.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(admin).deliver_later
    end

    redirect_to new_admin_session_path, notice: "Password reset instructions sent (if admin with that email address exists)."
  end

  def edit
  end

  def update
    if @admin.update(params.permit(:password, :password_confirmation))
      redirect_to new_admin_session_path, notice: "Password has been reset."
    else
      redirect_to edit_admin_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private
    def set_admin_by_token
      @admin = ::Admin.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_admin_password_path, alert: "Password reset link is invalid or has expired."
    end
end
