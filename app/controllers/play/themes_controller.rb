class Play::ThemesController < Users::BaseController
  def start
    @theme = Theme.find(params[:id])

    # Cancela qualquer tentativa in_progress anterior deste tema
    Current.user.theme_attempts.in_progress.where(theme: @theme).destroy_all

    @attempt = Current.user.theme_attempts.create!(theme: @theme, status: :in_progress)

    redirect_to play_theme_attempt_question_path(@attempt)
  end
end
