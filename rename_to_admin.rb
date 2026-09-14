Dir.glob([
  "app/**/*.rb", "app/**/*.erb", "test/**/*.rb", "config/routes.rb", "db/migrate/*.rb", "test/fixtures/*.yml"
]).each do |file|
  content = File.read(file)
  new_content = content
    .gsub("User", "Admin")
    .gsub("user", "admin")
    .gsub("Users", "Admins")
    .gsub("users", "admins")

  # For application_cable/connection.rb, current.user -> current.admin
  # For passwords_mailer, etc.
  File.write(file, new_content) if content != new_content
end

# Rename files
File.rename("app/models/user.rb", "app/models/admin.rb") if File.exist?("app/models/user.rb")
File.rename("test/models/user_test.rb", "test/models/admin_test.rb") if File.exist?("test/models/user_test.rb")
File.rename("test/fixtures/users.yml", "test/fixtures/admins.yml") if File.exist?("test/fixtures/users.yml")

Dir.glob("db/migrate/*_create_users.rb").each do |file|
  File.rename(file, file.gsub("create_users", "create_admins"))
end
