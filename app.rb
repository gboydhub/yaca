require 'sinatra'
require 'mysql2'
if File.exist?('local_env.rb')
  require_relative 'local_env.rb'
end


get '/' do
  ENV['INSTANCE_LOC']
end