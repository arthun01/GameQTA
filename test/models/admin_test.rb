require "test_helper"

class AdminTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    admin = Admin.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", admin.email_address)
  end
end
