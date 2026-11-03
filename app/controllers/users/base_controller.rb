class Users::BaseController < ApplicationController
  include Users::Authentication
  layout "student"
  before_action :require_current_legal_acceptance
  before_action :prevent_private_caching

  private
    def prevent_private_caching
      response.headers["Cache-Control"] = "no-store"
    end

    def require_current_legal_acceptance
      if Current.user.present? && !Current.user.current_legal_acceptance?
        redirect_to new_legal_acceptance_path
      end
    end
end
