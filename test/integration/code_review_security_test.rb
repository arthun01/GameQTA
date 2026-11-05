require "test_helper"
require "csv"

class CodeReviewSecurityTest < ActionDispatch::IntegrationTest
  test "password recovery delivers both formats with a usable administrative token" do
    admin = admins(:one)
    perform_enqueued_jobs do
      assert_difference "ActionMailer::Base.deliveries.count", 1 do
        post admin_passwords_path, params: { email_address: admin.email_address }
      end
    end
    message = ActionMailer::Base.deliveries.last
    assert_equal [ admin.email_address ], message.to
    [ message.text_part, message.html_part ].each do |part|
      assert_includes part.body.decoded, "/admin/passwords/"
      assert_includes part.body.decoded, "/edit"
    end
  end

  test "a real password reset revokes all old sessions and invalidates its token" do
    admin = admins(:one)
    sign_in_as admin
    old_session_ids = admin.sessions.pluck(:id)
    admin.sessions.create!
    token = admin.password_reset_token

    patch admin_password_path(token), params: { password: "new-password", password_confirmation: "new-password" }

    assert_redirected_to new_admin_session_path
    assert_empty admin.sessions.reload
    assert_not Session.exists?(id: old_session_ids)
    assert admin.reload.authenticate("new-password")
    get admin_root_path
    assert_redirected_to new_admin_session_path
    get edit_admin_password_path(token)
    assert_redirected_to new_admin_password_path
  end

  test "blank missing and unconfirmed reset passwords never report success" do
    admin = admins(:one)
    token = admin.password_reset_token
    digest = admin.password_digest
    [ {}, { password: "", password_confirmation: "" }, { password: "new-password" },
      { password: "new-password", password_confirmation: "other-password" } ].each do |attributes|
      patch admin_password_path(token), params: attributes
      assert_response :unprocessable_entity
      assert_equal digest, admin.reload.password_digest
    end
  end

  test "management password changes revoke existing sessions but email only edits do not" do
    actor = admins(:one)
    target = admins(:two)
    target.sessions.create!
    sign_in_as actor

    patch admin_admin_path(target), params: { admin: { email_address: "updated@example.com", password: "" } }
    assert_redirected_to admin_admins_path
    assert_equal 1, target.sessions.count

    patch admin_admin_path(target), params: { admin: { password: "changed-password", password_confirmation: "changed-password" } }
    assert_redirected_to admin_admins_path
    assert_empty target.sessions.reload
  end

  test "invalid administrative emails return form errors without persistence" do
    sign_in_as admins(:one)
    [ "", "not-an-email", " ONE@EXAMPLE.COM " ].each do |email|
      assert_no_difference "Admin.count" do
        post admin_admins_path, params: { admin: { email_address: email, password: "password", password_confirmation: "password" } }
      end
      assert_response :unprocessable_entity
    end
    target = admins(:two)
    original_email = target.email_address
    patch admin_admin_path(target), params: { admin: { email_address: admins(:one).email_address } }
    assert_response :unprocessable_entity
    assert_equal original_email, target.reload.email_address
  end

  test "level removal reports restrictions and only announces a real deletion" do
    sign_in_as admins(:one)
    assert_no_difference "Level.count" do
      delete admin_level_path(levels(:one))
    end
    assert_redirected_to admin_levels_path
    assert flash[:alert].present?
    assert_nil flash[:notice]
    assert_difference "Level.count", -1 do
      delete admin_level_path(levels(:level_without_themes))
    end
    assert flash[:notice].present?
  end

  test "spreadsheet exports neutralize untrusted text without changing stored profiles" do
    sign_in_as admins(:one)
    user = users(:student_one)
    [ "=1+1", "+1+1", "-1+1", "@SUM(1)", "\t=1+1", "\r=1+1", "\n=1+1", "  =1+1", "＝1+1", "\uFEFF=1+1", "\u200B=1+1" ].each do |value|
      user.update!(full_name: value, city: value)
      get students_admin_reports_path
      row = CSV.parse(response.body, headers: true).find { |record| record["ID"] == user.id.to_s }
      [ row["Nome"], row["Cidade"] ].each do |cell|
        assert cell.start_with?("'"), cell.inspect
      end
      assert_equal value.strip, user.reload.full_name
    end
  end
end
