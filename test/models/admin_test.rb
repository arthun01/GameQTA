require "test_helper"

class AdminTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    admin = Admin.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", admin.email_address)
  end

  test "validates presence, format and uniqueness of email_address" do
    admin = Admin.new(email_address: "", password: "password123")
    assert_not admin.valid?

    admin.email_address = "invalid-email"
    assert_not admin.valid?

    admin.email_address = admins(:one).email_address
    assert_not admin.valid?

    admin.email_address = "newadmin@example.com"
    assert admin.valid?
  end
end
