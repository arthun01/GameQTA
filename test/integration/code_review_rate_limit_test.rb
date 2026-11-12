require "test_helper"

class CodeReviewRateLimitTest < ActionDispatch::IntegrationTest
  test "recovery limits a normalized recipient across different origins without revealing existence" do
    messages = []
    assert_enqueued_emails 3 do
      6.times do |index|
        post admin_passwords_path, params: { email_address: " ONE@EXAMPLE.COM " },
          env: { "REMOTE_ADDR" => "198.51.100.#{index + 1}" }
        assert_redirected_to new_admin_session_path
        messages << flash[:notice]
      end
    end
    assert_equal 1, messages.uniq.count

    post admin_passwords_path, params: { email_address: "absent@example.com" }, env: { "REMOTE_ADDR" => "198.51.100.40" }
    assert_redirected_to new_admin_session_path
    assert_equal messages.first, flash[:notice]
  end

  test "recovery limits one origin even when recipient varies and expires after the window" do
    5.times do |index|
      post admin_passwords_path, params: { email_address: "absent#{index}@example.com" }
    end
    assert_no_enqueued_emails do
      post admin_passwords_path, params: { email_address: admins(:one).email_address }
    end

    travel 16.minutes do
      assert_enqueued_emails 1 do
        post admin_passwords_path, params: { email_address: admins(:one).email_address }
      end
    end
  end
end
