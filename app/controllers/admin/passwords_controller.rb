class Admin::PasswordsController < Admin::BaseController
  allow_unauthenticated_access
  before_action :set_admin_by_token, only: %i[ edit update ]
  rate_limit to: 5, within: 15.minutes, only: :create, name: "origin", with: :recovery_requested
  rate_limit to: 3, within: 15.minutes, only: :create, name: "recipient",
    by: -> { Digest::SHA256.hexdigest(params[:email_address].to_s.strip.downcase) }, with: :recovery_requested

  def new
  end

  def create
    if admin = ::Admin.find_by(email_address: params[:email_address].to_s.strip.downcase)
      PasswordsMailer.reset(admin).deliver_later
    end

    recovery_requested
  end

  def edit
  end

  def update
    @admin.assign_attributes(params.permit(:password, :password_confirmation))
    if @admin.save(context: :password_reset)
      redirect_to new_admin_session_path, notice: t(".success")
    else
      flash.now[:alert] = t(".invalid")
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def recovery_requested
      redirect_to new_admin_session_path, notice: t("admin.passwords.create.requested")
    end

    def set_admin_by_token
      @admin = ::Admin.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_admin_password_path, alert: t("admin.passwords.invalid_token")
    end
end
