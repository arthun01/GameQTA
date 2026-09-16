class Play::QuestionsController < Users::BaseController
  before_action :set_theme_attempt

  def show
    @question = @theme_attempt.next_pending_question

    if @question.nil?
      redirect_to jornada_path, notice: t(".theme_completed", default: "Tema concluído!")
    end
  end

  def reveal
    @question = @theme_attempt.next_pending_question
    @submission = @theme_attempt.question_submissions.create!(
      question: @question,
      revealed_at: Time.current
    )

    @time_limit = GameSetting.current.time_for_difficulty(@question.difficulty)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def submit
    @submission = @theme_attempt.question_submissions.order(created_at: :desc).first

    if @submission.nil? || @submission.option_id.present? || @submission.is_correct
      redirect_to play_theme_attempt_question_path(@theme_attempt)
      return
    end

    @question = @submission.question

    time_limit = GameSetting.current.time_for_difficulty(@question.difficulty)
    time_taken = Time.current - @submission.revealed_at

    is_timeout = time_taken > (time_limit + 2.seconds)
    option = Option.find_by(id: params[:option_id])

    if is_timeout
      @submission.update!(is_correct: false, option: nil)
    elsif option.present? && option.question_id == @question.id
      @submission.update!(is_correct: option.is_correct, option: option)
    else
      @submission.update!(is_correct: false, option: nil)
    end

    if @submission.is_correct?
      redirect_to play_theme_attempt_question_path(@theme_attempt)
    else
      respond_to do |format|
        format.turbo_stream
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
