class Users::LegalAcceptancesController < Users::BaseController
  skip_before_action :require_current_legal_acceptance

  def new
    @user = Current.user
  end

  def create
    @user = Current.user
    if @user.accept_legal_documents(accepted: params.dig(:user, :legal_documents_accepted), revision: params.dig(:user, :legal_revision))
      redirect_to jornada_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end
end
