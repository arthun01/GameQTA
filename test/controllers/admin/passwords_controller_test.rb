require "test_helper"

class Admin::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup { @admin = Admin.take }

  test "new" do
    get new_admin_password_path
    assert_response :success
  end

  test "create" do
    assert_enqueued_emails 1 do
      post admin_passwords_path, params: { email_address: @admin.email_address }
    end

    assert_redirected_to new_admin_session_path
  end

  test "edit" do
    get edit_admin_password_path(@admin.password_reset_token)
    assert_response :success
  end

  test "update" do
    patch admin_password_path(@admin.password_reset_token), params: { password: "new_password", password_confirmation: "new_password" }

    assert_redirected_to new_admin_session_path
    assert @admin.reload.authenticate("new_password")
  end
end
