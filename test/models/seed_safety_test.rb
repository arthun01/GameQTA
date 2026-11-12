require "test_helper"

class SeedSafetyTest < ActiveSupport::TestCase
  test "normal database preparation outside development never loads demonstration data" do
    assert_no_difference [ "Admin.count", "User.count", "Level.count", "Theme.count", "Question.count", "Option.count", "ThemeAttempt.count", "QuestionSubmission.count" ] do
      output, = capture_io { load Rails.root.join("db/seeds.rb") }
      assert_empty output
    end
  end
end

class AdminBootstrapTest < ActiveSupport::TestCase
  test "explicit provisioning uses external credentials without printing the password" do
    require "rake"
    Rails.application.load_tasks unless Rake::Task.task_defined?("admins:create")
    original_email = ENV["BOOTSTRAP_ADMIN_EMAIL"]
    original_password = ENV["BOOTSTRAP_ADMIN_PASSWORD"]
    ENV["BOOTSTRAP_ADMIN_EMAIL"] = "bootstrap-test@example.com"
    password = SecureRandom.hex(16)
    ENV["BOOTSTRAP_ADMIN_PASSWORD"] = password

    assert_difference "Admin.count", 1 do
      output, errors = capture_io do
        task = Rake::Task["admins:create"]
        task.reenable
        task.invoke
      end
      assert_not_includes output + errors, password
    end
    assert Admin.find_by!(email_address: "bootstrap-test@example.com").authenticate(password)
  ensure
    ENV["BOOTSTRAP_ADMIN_EMAIL"] = original_email
    ENV["BOOTSTRAP_ADMIN_PASSWORD"] = original_password
  end
end
