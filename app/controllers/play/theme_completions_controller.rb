class Play::ThemeCompletionsController < Users::BaseController
  def create
    theme = Theme.find(params[:theme_id])
    attempt = Current.user.theme_attempts.find_by(id: params[:attempt_id], theme: theme)
    if attempt
      result = attempt.complete
      if result
        session[:level_result] = result
        completion_destination(theme, result)
      else
        redirect_to play_theme_attempt_question_path(attempt), alert: attempt.errors.full_messages.to_sentence
      end
    elsif previous_result_for?(theme, params[:attempt_id])
      completion_destination(theme, session[:level_result])
    else
      redirect_to jornada_path
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to jornada_path
  end

  def show
    theme = Theme.find(params[:id])
    result = session[:level_result]
    if previous_result_for?(theme) && result["level_finished"]
      @level = theme.level
      @score = result["score"]
      @passed = result["passed"]
      render "play/themes/finish"
    else
      redirect_to jornada_path
    end
  end

  private
    def completion_destination(theme, result)
      if result["level_finished"]
        redirect_to finish_play_theme_path(theme), status: :see_other
      else
        redirect_to jornada_path, notice: t(".theme_completed"), status: :see_other
      end
    end

    def previous_result_for?(theme, attempt_id = nil)
      result = session[:level_result]
      result.present? && result["user_id"] == Current.user.id && result["theme_id"] == theme.id &&
        (attempt_id.nil? || result["attempt_id"].to_s == attempt_id.to_s)
    end
end
