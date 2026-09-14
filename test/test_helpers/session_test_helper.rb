module SessionTestHelper
  def sign_in_as(admin)
    Current.session = admin.sessions.create!

    ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
      cookie_jar.signed[:session_id] = Current.session.id
      cookies["session_id"] = cookie_jar[:session_id]
    end
  end

  def sign_out
    Current.session&.destroy!
    cookies.delete("session_id")
  end

  def sign_in_as_user(user)
    Current.user_session = user.user_sessions.create!

    ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
      cookie_jar.signed[:user_session_id] = Current.user_session.id
      cookies["user_session_id"] = cookie_jar[:user_session_id]
    end
  end

  def sign_out_user
    Current.user_session&.destroy!
    cookies.delete("user_session_id")
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include SessionTestHelper
end
