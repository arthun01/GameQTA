require "csv"

class Admin::ReportsController < Admin::BaseController
  def index
  end

  def students
    headers.delete("Content-Length")
    headers["Cache-Control"] = "no-store"
    headers["Content-Type"] = "text/csv; charset=utf-8"
    headers["Content-Disposition"] = "attachment; filename=\"relatorio_estudantes_#{Date.today}.csv\""
    headers["X-Accel-Buffering"] = "no"

    self.response_body = Enumerator.new do |y|
      y << SpreadsheetExport.row(t("admin.reports.students_headers"))

      User.includes(:leaderboard).find_each(batch_size: 1000) do |user|
        score = user.leaderboard&.total_score || 0
        time = user.leaderboard&.total_time_taken || 0
        status = user.blocked? ? t("admin.reports.blocked") : t("admin.reports.active")

        y << SpreadsheetExport.row([
          user.id,
          user.full_name,
          user.email_address,
          user.city,
          user.education_level,
          score,
          time,
          status,
          user.created_at.to_s
        ])
      end
    end
  end

  def themes
    headers.delete("Content-Length")
    headers["Cache-Control"] = "no-store"
    headers["Content-Type"] = "text/csv; charset=utf-8"
    headers["Content-Disposition"] = "attachment; filename=\"relatorio_temas_#{Date.today}.csv\""
    headers["X-Accel-Buffering"] = "no"

    self.response_body = Enumerator.new do |y|
      y << SpreadsheetExport.row(t("admin.reports.themes_headers"))

      statistics = Theme.report_statistics

      Theme.includes(:level).find_each(batch_size: 100) do |theme|
        attempts = statistics[:attempts][theme.id] || 0
        total = statistics[:responses][theme.id] || 0
        correct = statistics[:correct][theme.id] || 0
        rate = total > 0 ? (correct.to_f / total * 100).round(1) : 0.0

        y << SpreadsheetExport.row([
          theme.id,
          theme.name,
          theme.level.name,
          attempts,
          total,
          correct,
          "#{rate}%"
        ])
      end
    end
  end
end
