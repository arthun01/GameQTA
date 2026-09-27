class Admin::StudentsController < Admin::BaseController
  before_action :set_student, only: %i[ block unblock ]

  def index
    @students = User.all.order(created_at: :desc)
  end

  def block
    @student.block!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("user_#{@student.id}", partial: "admin/students/student", locals: { student: @student }) }
      format.html { redirect_to admin_students_path, notice: "Estudante bloqueado com sucesso." }
    end
  end

  def unblock
    @student.unblock!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("user_#{@student.id}", partial: "admin/students/student", locals: { student: @student }) }
      format.html { redirect_to admin_students_path, notice: "Estudante desbloqueado com sucesso." }
    end
  end

  private

  def set_student
    @student = User.find(params[:id])
  end
end
