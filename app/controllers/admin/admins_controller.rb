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

    if @admin_user.save
      redirect_to admin_admins_path, notice: "Administrador criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @admin_user.update(admin_params)
      redirect_to admin_admins_path, notice: "Administrador atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if Admin.count <= 1
      redirect_to admin_admins_path, alert: "Não é possível excluir o único administrador do sistema."
    elsif @admin_user == Current.admin
      redirect_to admin_admins_path, alert: "Você não pode excluir a si mesmo."
    else
      @admin_user.destroy!
      redirect_to admin_admins_path, notice: "Administrador excluído com sucesso."
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
