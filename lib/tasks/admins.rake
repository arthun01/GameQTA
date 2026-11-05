namespace :admins do
  desc "Provision an administrator using BOOTSTRAP_ADMIN_EMAIL and BOOTSTRAP_ADMIN_PASSWORD"
  task create: :environment do
    email = ENV.fetch("BOOTSTRAP_ADMIN_EMAIL")
    password = ENV.fetch("BOOTSTRAP_ADMIN_PASSWORD")
    abort I18n.t("admin.bootstrap.password_too_short") if password.length < 12

    Admin.create!(email_address: email, password: password, password_confirmation: password)
    puts I18n.t("admin.bootstrap.created")
  end
end
