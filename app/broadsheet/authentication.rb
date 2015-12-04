class Broadsheet
  module Authentication
    def self.registered(app)
      app.before do
        begin
          if session[:id]
            puts "Sessioned (#{session[:id]})"
            @session = Broadsheet::Session[session[:id].to_i]
            fail unless @session.valid?
          else
            false
          end
        rescue
          puts "Invalid session!"
          @session = nil
          session.clear
          false
        end
      end

      app.after do
        if @session
          session[:id] = @session.id
        else
          session.clear
        end
      end

      app.set :auth do |expected|
        condition do
          authed = @session ? !@session.owner_id.nil? : false
          authed == expected
        end
      end
    end
  end
end
