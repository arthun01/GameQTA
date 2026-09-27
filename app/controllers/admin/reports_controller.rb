require "csv"

class Admin::ReportsController < Admin::BaseController
  def index
  end

  def students
    headers.delete("Content-Length")
    headers["Cache-Control"] = "no-cache"
    headers["Content-Type"] = "text/csv; charset=utf-8"
    headers["Content-Disposition"] = "attachment; filename=\"relatorio_estudantes_#{Date.today}.csv\""
    headers["X-Accel-Buffering"] = "no"

    self.response_body = Enumerator.new do |y|
      y << CSV.generate_line(%w[ID Nome Email Cidade Nivel_Educacao Pontuacao_Total Tempo_Total Status_Bloqueio Criado_em])

      User.includes(:leaderboard).find_each(batch_size: 1000) do |user|
        score = user.leaderboard&.total_score || 0
        time = user.leaderboard&.total_time_taken || 0
        status = user.blocked? ? "Bloqueado" : "Ativo"

        y << CSV.generate_line([
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
    headers["Cache-Control"] = "no-cache"
    headers["Content-Type"] = "text/csv; charset=utf-8"
    headers["Content-Disposition"] = "attachment; filename=\"relatorio_temas_#{Date.today}.csv\""
    headers["X-Accel-Buffering"] = "no"

    self.response_body = Enumerator.new do |y|
      y << CSV.generate_line(%w[ID Tema Nivel Total_Tentativas Total_Acertos Taxa_Acertos])

      # Duas queries agregadas otimizadas para evitar N+1 queries (100% O(1) loop)
      total_por_tema = QuestionSubmission.joins(:theme_attempt).group("theme_attempts.theme_id").count
      corretos_por_tema = QuestionSubmission.joins(:theme_attempt).where(is_correct: true).group("theme_attempts.theme_id").count

      Theme.includes(:level).find_each(batch_size: 100) do |theme|
        total = total_por_tema[theme.id] || 0
        correct = corretos_por_tema[theme.id] || 0
        rate = total > 0 ? (correct.to_f / total * 100).round(1) : 0.0

        y << CSV.generate_line([
          theme.id,
          theme.name,
          theme.level.name,
          total,
          correct,
          "#{rate}%"
        ])
      end
    end
  end
end
