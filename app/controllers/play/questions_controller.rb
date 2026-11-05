class Play::QuestionsController < Users::BaseController
  before_action :set_theme_attempt

  def show
    @question = @theme_attempt.next_pending_question

    if @question.nil?
      redirect_to finish_play_theme_path(@theme_attempt.theme)
    end
  end

  def reveal
    @submission = @theme_attempt.reveal_question(time_multiplier: params[:time_multiplier])
    if @submission.nil?
      redirect_to finish_play_theme_path(@theme_attempt.theme)
      return
    end
    @question = @submission.question

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to play_theme_attempt_question_path(@theme_attempt) }
    end
  end

  def submit
    @submission = @theme_attempt.question_submissions.find_by(id: params[:submission_id])

    if @submission.nil? || @submission.answered_at.present? || @submission.option_id.present?
      redirect_to play_theme_attempt_question_path(@theme_attempt)
      return
    end

    @question = @submission.question

    @submission.answer(option_id: params[:option_id])

    if @submission.is_correct?
      redirect_to play_theme_attempt_question_path(@theme_attempt)
    else
      respond_to do |format|
        format.turbo_stream
        format.html do
          @show_feedback_modal = true
          render :show
        end
      end
    end
  end

  private

  def set_theme_attempt
    @theme_attempt = Current.user.theme_attempts.find(params[:theme_attempt_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to jornada_path, alert: t("play.questions.unauthorized", default: "Tentativa inválida ou não autorizada.")
  end
end
