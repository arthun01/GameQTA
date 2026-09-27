require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:student_one)
    @user.update(password: "password123")
  end

  test "should get new" do
    get "/entrar"
    assert_response :success
  end

  test "should create session for valid user" do
    post "/entrar", params: { email_address: @user.email_address, password: "password123" }
    assert_redirected_to "/jornada"
  end

  test "should not create session if user is blocked" do
    @user.block!

    post "/entrar", params: { email_address: @user.email_address, password: "password123" }
    assert_redirected_to "/entrar"
    assert_equal "Sua conta foi bloqueada por infração às regras.", flash[:alert]
  end

  test "should not create session with invalid credentials" do
    post "/entrar", params: { email_address: @user.email_address, password: "wrong" }
    assert_redirected_to "/entrar"
    assert_equal "E-mail ou senha incorretos.", flash[:alert]
  end
end
