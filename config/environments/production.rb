# You can't catch me, NSA!
Broadsheet::Middleware.use Rack::SslEnforcer

# TODO(mtwilliams): Whitelist administrative access.
Broadsheet::Middleware.use Rack::Access, '/' => '0.0.0.0/0'

# Tag requests with a unique identifier.
Broadsheet::Middleware.use Broadsheet::RequestTracker

# Record performance using Skylight.
 # => Sinatra (+ Tilt), Sequel, and Redis.
Broadsheet::Middleware.use Skylight::Middleware

# Appologize on errors.
Broadsheet::Middleware.use Broadsheet::ErrorHandler

# Report errors to Sentry.
Broadsheet::Middleware.use Broadsheet::ErrorReporter

# Once you're here. You're here. Forever...
Broadsheet::Sessions.configure do
  # Microservice compatible!
  domain ".#{PublicSuffix.parse(ENV['HOST'])}"
  path "/"
  expires 1.year
  secret ENV['SESSION_SECRET']
end

Broadsheet::Database.configure do
  Tetrahedron::Database::Postgres.new do
    url = URI[ENV['DATABASE_URL']]
    user = url.user
    password = url.password
    host = url.host
    port = url.port
    database = url.path[1..-1]
  end
end

Broadsheet::Cache.configure do
  Tetrahedron::Caches::Redis.new do
    url = URI[ENV['REDIS_URL']]
    host = url.host
    port = url.port
    database = url.path[1..-1].to_i
  end
end

Broadsheet::Queue.configure do
  Tetrahedron::Queue::Sidekiq.new do
    url = URI[ENV['REDIS_URL']]
    redis host: url.host,
          port: url.port
          database: url.path[1..-1].to_i
  end
end
