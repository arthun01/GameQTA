class PasswordsMailer < ApplicationMailer
  def reset(admin)
    @admin = admin
    mail subject: t("passwords_mailer.reset.subject"), to: admin.email_address
  end
end
