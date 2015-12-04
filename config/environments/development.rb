# Things are going to break. When they do, this will make debugging much less
# painful.

# HACK(mtwilliams): Use a single BetterError::Middleware instance.
# Refer to https://github.com/charliesome/better_errors/issues/301#issuecomment-160739421
class BetterErrors::Middleware::Proxy
  @@middleware = BetterErrors::Middleware.new(proc {|env| @@app.call(env)})
  def initialize(app); @@app = app; end
  def call(env); @@middleware.call(env); end
end

Broadsheet::Middleware.use BetterErrors::Middleware::Proxy # BetterErrors::Middleware
BetterErrors.application_root = Broadsheet.root

Broadsheet::Sessions.configure do
  domain ".localhost"
  path "/"
  expires 60.minutes
  # Force sessions to expire during different development instances so
  # transient state doesn't cause weird errors.
  secret SecureRandom.hex(32)
end

Broadsheet::Database.configure do
  # For similar reasons, use a fresh database during different development
  # instances as well.
  Tetrahedron::Databases::SQLite3.new do
    self.path = "db/development.sqlite3"
  end
end

# Broadsheet::Cache.configure do
#   # Don't cache; tarpits should be discovered during development.
#   Tetrahedron::Caches::Null.new
# end

# Broadsheet::Queue.configure do
#   # Do asynchronous work in a thread pool.
#   Tetrahedron::Queue::Background.new do
#     pool [1, Facter.value('processors')['count'].to_i - 1].max
#   end
# end

Mail.defaults do
  require 'broadsheet/log_mail_delivery'
  delivery_method Broadsheet::LogMailDelivery
end
