class Play::ThemeAttemptsController < Users::BaseController
  def create
    theme = Theme.find(params[:id])
    attempt = Current.user.start_theme(theme)
    if attempt
      redirect_to play_theme_attempt_question_path(attempt)
    else
      redirect_to jornada_path, alert: Current.user.errors.full_messages.to_sentence
    end
  end
end
