class Admin::QuestionsController < Admin::BaseController
  before_action :set_theme, only: %i[index new create]
  before_action :set_question, only: %i[show edit update destroy]

  def index
    @questions = @theme.questions.order(created_at: :desc)
  end

  def show
  end

  def new
    @question = @theme.questions.build
    # Build options initially to show in the form
    @question.options.build
    @question.options.build
  end

  def create
    @question = @theme.questions.build(question_params)
    if @question.save
      redirect_to admin_theme_questions_path(@theme), notice: t(".success", default: "Questão criada com sucesso.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to admin_theme_questions_path(@question.theme), notice: t(".success", default: "Questão atualizada com sucesso.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @theme = @question.theme
    @question.destroy
    redirect_to admin_theme_questions_path(@theme), notice: t(".success", default: "Questão removida com sucesso."), status: :see_other
  end

  private

  def set_theme
    @theme = Theme.find(params[:theme_id])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:statement, :youtube_link, :feedback_article, :difficulty, options_attributes: [ :id, :content, :is_correct, :_destroy ])
  end
end
