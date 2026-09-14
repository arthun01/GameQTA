require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @admin = Admin.take }

  test "new" do
    get new_admin_session_path
    assert_response :success
  end

  test "create with valid credentials" do
    post admin_session_url, params: { email_address: @admin.email_address, password: "password" }

    assert_redirected_to admin_root_url
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post admin_session_path, params: { email_address: @admin.email_address, password: "wrong" }

    assert_redirected_to new_admin_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(Admin.take)

    delete admin_session_path

    assert_redirected_to new_admin_session_path
    assert_empty cookies[:session_id]
  end
end
