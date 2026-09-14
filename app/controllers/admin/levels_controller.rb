class Admin::LevelsController < Admin::BaseController
  before_action :set_level, only: %i[show edit update destroy]

  def index
    @levels = Level.all.order(:name)
  end

  def show
  end

  def new
    @level = Level.new
  end

  def create
    @level = Level.new(level_params)
    if @level.save
      redirect_to admin_levels_path, notice: t(".success", default: "Nível criado com sucesso.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @level.update(level_params)
      redirect_to admin_levels_path, notice: t(".success", default: "Nível atualizado com sucesso.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @level.destroy
    redirect_to admin_levels_path, notice: t(".success", default: "Nível removido com sucesso."), status: :see_other
  end

  private

  def set_level
    @level = Level.find(params[:id])
  end

  def level_params
    params.expect(level: [ :name, :description, :icon ])
  end
end
