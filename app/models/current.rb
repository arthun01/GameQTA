class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :admin, to: :session, allow_nil: true

  attribute :user_session
  delegate :user, to: :user_session, allow_nil: true
end
