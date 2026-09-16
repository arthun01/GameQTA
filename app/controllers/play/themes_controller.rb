class Play::ThemesController < Users::BaseController
  def start
    @theme = Theme.find(params[:id])

    # Cancela qualquer tentativa in_progress anterior deste tema
    Current.user.theme_attempts.in_progress.where(theme: @theme).destroy_all

    @attempt = Current.user.theme_attempts.create!(theme: @theme, status: :in_progress)

    redirect_to play_theme_attempt_question_path(@attempt)
  end

  def finish
    @theme = Theme.find(params[:id])
    @attempt = Current.user.theme_attempts.order(created_at: :desc).find_by(theme: @theme)

    if @attempt.nil?
      redirect_to jornada_path
      return
    end

    if @attempt.in_progress?
      @attempt.update!(status: :completed)
    end

    @level = @theme.level

    if @level.last_theme?(@theme)
      @score = @level.score_for(Current.user)
      if @score < 70.0
        @level.reset_progress_for!(Current.user)
        @passed = false
      else
        @passed = true
      end
    else
      redirect_to jornada_path, notice: t(".theme_completed", default: "Tema concluído com sucesso!")
    end
  end
end
