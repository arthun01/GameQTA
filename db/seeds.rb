# Demonstration data must never be loaded by normal database preparation.
if Rails.env.development? && ENV["LOAD_DEMO_DATA"] == "1"
  load Rails.root.join("db/seeds/development.rb")
end
