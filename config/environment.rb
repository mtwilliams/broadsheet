Broadsheet.root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

Bundler.require(Broadsheet.env.to_sym)

# TODO(mtwilliams): Setup our Content Origin Policies for an API.
# Broadsheet::Middleware.use Rack::Cors do
#   allow do
#     origins '*'
#     resource '*', :headers => :any,
#                   :methods => %w{get post put patch delete link unlink}
#   end
# end

require_relative "environments/#{Broadsheet.env.to_s}"

Broadsheet::Database.connect

if Broadsheet.env.development?
  puts "Running database migrations..."
  Broadsheet::Database.migrate("#{Broadsheet.root}/db/migrations")
end
