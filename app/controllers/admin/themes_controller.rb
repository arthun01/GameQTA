class Admin::ThemesController < Admin::BaseController
  before_action :set_level, only: %i[index new create]
  before_action :set_theme, only: %i[show edit update destroy]

  def index
    @themes = @level.themes.order(:name)
  end

  def show
  end

  def new
    @theme = @level.themes.build
  end

  def create
    @theme = @level.themes.build(theme_params)
    if @theme.save
      redirect_to admin_level_themes_path(@level), notice: t(".success", default: "Tema criado com sucesso.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @theme.update(theme_params)
      redirect_to admin_level_themes_path(@theme.level), notice: t(".success", default: "Tema atualizado com sucesso.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @level = @theme.level
    if @theme.destroy
      redirect_to admin_level_themes_path(@level), notice: t(".success", default: "Tema removido com sucesso."), status: :see_other
    else
      redirect_to admin_level_themes_path(@level), alert: t(".error", default: "Não foi possível remover o tema."), status: :see_other
    end
  end

  private

  def set_level
    @level = Level.find(params[:level_id])
  end

  def set_theme
    @theme = Theme.find(params[:id])
  end

  def theme_params
    params.expect(theme: [ :name, :description, :icon ])
  end
end
