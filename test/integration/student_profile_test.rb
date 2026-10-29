require "test_helper"

class StudentProfileTest < ActionDispatch::IntegrationTest
  test "profile and its actions require student authentication" do
    get profile_path
    assert_redirected_to entrar_path
    patch profile_path, params: { user: { full_name: "Other" } }
    assert_redirected_to entrar_path
    assert_no_difference "User.count" do
      delete profile_path, params: { user: { current_password: "password", deletion_confirmed: "1" } }
    end
    assert_redirected_to entrar_path
  end

  test "profile shows only the current student and avoids caching" do
    sign_in_as_user users(:student_one)
    get profile_path

    assert_response :success
    assert_equal "no-store", response.headers["Cache-Control"]
    assert_select "h1", "Meu perfil e meus dados"
    assert_select "dd", text: users(:student_one).email_address
    assert_select "dd", text: users(:student_two).email_address, count: 0
    assert_select "form input[name='_method'][value='delete']"
    assert_select "input[name='user[deletion_confirmed]']:not([checked])"
  end

  test "profile updates allowed fields but cannot change password permissions or another student" do
    user = users(:student_one)
    other = users(:student_two)
    sign_in_as_user user
    original_digest = user.password_digest

    patch profile_path, params: { user: {
      id: other.id, full_name: "Nome corrigido", city: "", education_level: "", current_password: "password",
      password: "forged-password", blocked_at: Time.current, accepted_terms_at: Time.current
    } }

    assert_redirected_to profile_path
    assert_equal "Nome corrigido", user.reload.full_name
    assert_nil user.city
    assert_nil user.education_level
    assert_nil user.blocked_at
    assert_equal original_digest, user.password_digest
    assert_equal "Maria Estudante", other.reload.full_name
  end

  test "invalid credentials and invalid profile values cannot change the account" do
    user = users(:student_one)
    sign_in_as_user user

    patch profile_path, params: { user: { full_name: "Changed", current_password: "wrong" } }
    assert_response :unprocessable_entity
    assert_select "[role=alert]", text: /Senha atual está incorreta/
    assert_equal "João Aluno", user.reload.full_name

    patch profile_path, params: { user: { age: -1, education_level: "invalid", current_password: "password" } }
    assert_response :unprocessable_entity
    assert_equal 18, user.reload.age
    assert_equal "medio_completo", user.education_level
  end

  test "deletion failures preserve all data and a successful request invalidates every session" do
    user = users(:student_one)
    second_session = user.user_sessions.create!
    sign_in_as_user user

    assert_no_difference "User.count" do
      delete profile_path, params: { user: { current_password: "password", deletion_confirmed: "0" } }
    end
    assert_response :unprocessable_entity
    assert_select "[role=alert]", text: /Confirmação de exclusão/

    assert_difference "User.count", -1 do
      delete profile_path, params: { user: { id: users(:student_two).id, current_password: "password", deletion_confirmed: "1" } }
    end
    assert_redirected_to entrar_path
    assert_not UserSession.exists?(second_session.id)
    assert_empty cookies[:user_session_id].to_s
    assert User.exists?(users(:student_two).id)

    get jornada_path
    assert_redirected_to entrar_path
  end
end
