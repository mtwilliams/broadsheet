require_relative 'application'
require_relative 'environment'

rackup      DefaultRackup

environment Broadsheet.env.to_s
bind        "tcp://0.0.0.0:#{ENV['PORT']||9292}"
port        (ENV['PORT']||9292).to_i
workers     (ENV['PUMA_WORKERS']||1).to_i
threads     (ENV['PUMA_THREADS_MIN']||1).to_i,
            (ENV['PUMA_THREADS_MAX']||1).to_i

preload_app!

before_fork do
  puts "Killing service connections before forking..."
  Broadsheet::Database.disconnect
end

on_worker_boot do
  puts "Establishing service connections..."
  Broadsheet::Database.connect
end

# TODO(mtwilliams): Report low-level errors in production.
 # lowlevel_error_handler do |e|
 #   ...
 # end
