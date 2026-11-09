class Admin::PasswordsController < Admin::BaseController
  allow_unauthenticated_access
  before_action :set_admin_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if admin = ::Admin.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(admin).deliver_later
    end

    redirect_to new_admin_session_path, notice: t(".sent")
  end

  def edit
  end

  def update
    if @admin.update(params.permit(:password, :password_confirmation))
      redirect_to new_admin_session_path, notice: t(".success")
    else
      redirect_to edit_admin_password_path(params[:token]), alert: t(".mismatch")
    end
  end

  private
    def set_admin_by_token
      @admin = ::Admin.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_admin_password_path, alert: t("admin.passwords.invalid_token")
    end
end
