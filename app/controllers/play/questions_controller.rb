class Play::QuestionsController < Users::BaseController
  before_action :set_theme_attempt

  def show
    @question = @theme_attempt.next_pending_question

    if @question.nil?
      # Tema finalizado! (A lógica completa virá na task 5)
      redirect_to jornada_path, notice: t(".theme_completed", default: "Tema concluído!")
    end
  end

  def reveal
    # A implementar na task 3
  end

  def submit
    # A implementar na task 4
  end

  private

  def set_theme_attempt
    @theme_attempt = Current.user.theme_attempts.find(params[:theme_attempt_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to jornada_path, alert: t("play.questions.unauthorized", default: "Tentativa inválida ou não autorizada.")
  end
end
