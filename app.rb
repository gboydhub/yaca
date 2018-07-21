require 'sinatra'
if File.exist?(local_env.rb)
  require_relative 'local_env.rb'
end


get '/' do
  ENV['INSTANCE_LOC']
end