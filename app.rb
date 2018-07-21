require 'sinatra'
require 'mysql2'
require_relative 'database.rb'
enable :sessions

get '/' do
  erb :test_user
end

post '/create_user' do
  uname = params[:username]
  pass = params[:password]

  db = DataBase.new
  db.connect
  result = db.client.query("INSERT INTO users (`name`, `password`) VALUES (AES_ENCRYPT('#{uname}', #{ENV['AES_KEY']}), AES_ENCRYPT('#{pass}', #{ENV['AES_KEY']}))")
  p result.first
  redirect '/'
end

# SELECT CAST(AES_DECRYPT(name, AES_KEY) AS CHAR(50)) FROM `users` WHERE id=1