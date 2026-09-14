class PasswordsMailer < ApplicationMailer
  def reset(admin)
    @admin = admin
    mail subject: "Reset your password", to: admin.email_address
  end
end
