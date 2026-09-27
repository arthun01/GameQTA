class Admin::DashboardsController < Admin::BaseController
  def show
    @total_students = User.count
    @themes_completed = ThemeAttempt.count

    total_submissions = QuestionSubmission.count
    correct_submissions = QuestionSubmission.where(is_correct: true).count

    @global_accuracy = if total_submissions > 0
      (correct_submissions.to_f / total_submissions * 100).round(1)
    else
      0
    end
  end
end
