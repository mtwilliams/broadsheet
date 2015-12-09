source 'https://rubygems.org'
ruby '2.2.3'
 # TODO(mtwilliams): Use Rubinius.
  # ^ :engine => 'rbx', :engine_version => '2.5.8'

gem 'dotenv'
gem 'pry'
gem 'rake'
gem 'yard', :group => [:development]
gem 'airborne', :group => [:development, :test]
gem 'mocha', :group => [:development, :test]

# I don't know how to live without these.
gem 'byebug', :group => :development
gem 'better_errors', :group => :development
gem 'binding_of_caller', :group => :development
gem 'raven', :group => [:production, :staging]
gem 'skylight', :require => ['skylight/sinatra'], :group => [:production, :staging]

# Web scale.
gem 'puma'

# On the Tet.
gem 'tetrahedron'
gem 'rack'
gem 'rack-contrib', :require => 'rack/contrib'
gem 'rack-ssl-enforcer', :require => 'rack/ssl-enforcer'
gem 'sinatra', :require => 'sinatra/base'
gem 'sinatra-contrib', :require => 'sinatra/contrib/all'
gem 'tilt'

# Erubis for HTML.
gem 'erubis'

# SQLite3/Postgres for DB.
gem 'sequel'
# SQLite3 for simplicty.
gem 'sqlite3', :group => :development
# Postgres in the real world.
gem 'pg', :group => [:production, :staging]
# Improve row-fetching performance.
gem 'sequel_pg', :group => [:production, :staging]

# Redis for caching and work queues.
gem 'redis', :require => ['redis', 'redis/connection/hiredis'], :group => [:production, :staging]
gem 'hiredis', :group => [:production, :staging]
gem 'connection_pool', :group => [:production, :staging]

# The trusty ol' mail gem for email.
gem 'mail'
# TODO(mtwilliams): Use Postmark.
 # gem 'postmark', :group => [:production, :staging]
# TODO(mtwilliams): Use the letter_opener gem in development.
 # gem 'letter_opener', :group => [:development]
 # gem 'letter_opener_web', :group => [:development]

# Infrastructure.
gem 'activesupport'
gem 'public_suffix'
gem 'facter', :group => [:development, :test]
gem 'http'
