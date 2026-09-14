class DashboardController < Users::BaseController
  def index
    @levels = Level.includes(:themes).order(:id)
  end
end
