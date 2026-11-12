require "test_helper"

class CookiePrivacyTest < ActionDispatch::IntegrationTest
  test "public and authenticated pages have no automatic external resources" do
    [ entrar_path, cadastrar_path, terms_path, privacy_policy_path, accessibility_path, new_admin_session_path ].each do |path|
      get path
      assert_response :success
      assert_select "iframe, link[rel=preconnect], link[href*='fonts.googleapis.com'], script[src^='https://']", count: 0
      assert_select ".cookie-notice", count: 1
    end
    sign_in_as_user users(:student_one)
    get play_theme_attempt_question_path(theme_attempts(:one))
    assert_response :success
    assert_select "iframe", count: 0
    assert_select "[data-controller=external-video] button", text: "Assistir vídeo"
    assert_select "button[data-action='external-video#reject']", count: 0
  end

  test "authentication cookie is limited and protected and logout revokes server record" do
    post entrar_path, params: { email_address: users(:student_one).email_address, password: "password" }
    header = Array(response.headers["Set-Cookie"]).find { |cookie| cookie.start_with?("user_session_id=") }
    assert_match(/httponly/i, header)
    assert_match(/samesite=lax/i, header)
    assert_match(/expires=/i, header)
    refute_match(/204\d/, header)
    session = UserSession.order(:created_at).last
    delete sair_path
    assert_not UserSession.exists?(session.id)
    get jornada_path
    assert_redirected_to entrar_path
  end

  test "server rejects an expired student and administrator session" do
    sign_in_as_user users(:student_one)
    users(:student_one).user_sessions.update_all(created_at: 13.hours.ago)
    get jornada_path
    assert_redirected_to entrar_path

    sign_in_as admins(:one)
    admins(:one).sessions.update_all(created_at: 13.hours.ago)
    get admin_root_path
    assert_redirected_to new_admin_session_path
  end

  test "invalid registration exposes errors associated with the original field" do
    post cadastrar_path, params: { user: { full_name: "Pessoa", age: 4, email_address: "person@example.com", password: "password123" } }
    assert_response :unprocessable_entity
    assert_select "input[name='user[age]'][aria-invalid=true][aria-describedby='user_age_error']"
    assert_select "#user_age_error", text: /5/
    assert_select "input[name='user[full_name]'][value=Pessoa]"
  end
end
