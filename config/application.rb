require 'rubygems'
require 'bundler'

Bundler.require(:default)

begin
  require 'dotenv'
  $stdout.puts "Loading environment from `.env` if available..."
  Dotenv.load! File.join(File.dirname(__FILE__), '..', '.env')
  $stdout.puts " => Loaded from `.env`."
rescue LoadError => _
  $stderr.puts "The 'dotenv' Gem is not available on this system!"
  if File.exist?(File.join(File.dirname(__FILE__), '..', '.env'))
    $stderr.puts " => Skipping `.env` file."
  end
rescue Errno::ENOENT
  $stderr.puts " => No `.env` file."
  false
end

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'app'))
require 'broadsheet'
