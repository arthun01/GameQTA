content = File.read("app/controllers/concerns/authentication.rb")
new_content = content.sub(
  /def find_session_by_cookie.*?end/m,
  <<~RUBY
    def find_session_by_cookie
      begin
        puts "DEBUG: Calling cookies.signed"
        val = cookies.signed[:session_id]
        puts "DEBUG: val is \#{val.inspect}"
        if val
          puts "DEBUG: Calling ::Session.find_by"
          ::Session.find_by(id: val)
        end
      rescue => e
        puts "DEBUG ERROR: \#{e.class} - \#{e.message}"
        puts e.backtrace.first(5).join("\n")
        raise e
      end
    end
  RUBY
)
File.write("app/controllers/concerns/authentication.rb", new_content)
