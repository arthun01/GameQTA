class Admin::AdminsController < Admin::BaseController
  before_action :set_admin_user, only: %i[ edit update destroy ]

  def index
    @admins = Admin.all.order(created_at: :desc)
  end

  def new
    @admin_user = Admin.new
  end

  def edit
  end

  def create
    @admin_user = Admin.new(admin_params)

    if @admin_user.save_for_team
      redirect_to admin_admins_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @admin_user.save_for_team(admin_params)
      redirect_to admin_admins_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @admin_user.remove_from_team(actor: Current.admin)
      redirect_to admin_admins_path, notice: t(".success"), status: :see_other
    else
      redirect_to admin_admins_path, alert: @admin_user.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private
    def set_admin_user
      @admin_user = Admin.find(params[:id])
    end

    def admin_params
      # Se a senha vier em branco durante a edição, removemos para não quebrar a validação do has_secure_password
      p = params.require(:admin).permit(:email_address, :password, :password_confirmation)
      p.delete(:password) if p[:password].blank?
      p.delete(:password_confirmation) if p[:password_confirmation].blank?
      p
    end
end
