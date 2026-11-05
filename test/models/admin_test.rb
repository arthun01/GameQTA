require "test_helper"

class AdminTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    admin = Admin.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", admin.email_address)
  end

  test "the last administrator cannot be destroyed through the model" do
    admins(:two).destroy!
    admin = admins(:one)
    session = admin.sessions.create!

    assert_no_difference [ "Admin.count", "Session.count" ] do
      assert_not admin.destroy
    end
    assert admin.errors.of_kind?(:base, :last_admin)
    assert Session.exists?(session.id)
  end
end
