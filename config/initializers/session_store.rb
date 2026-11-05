Rails.application.config.session_store :cookie_store,
  key: "_qta_rails8_session", expire_after: 12.hours,
  httponly: true, same_site: :lax, secure: Rails.env.production?
