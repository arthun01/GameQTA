class ApplicationMailer < ActionMailer::Base
  default from: -> { Rails.env.production? ? ENV.fetch("MAILER_FROM") : ENV.fetch("MAILER_FROM", "from@example.com") }
  layout "mailer"
end
