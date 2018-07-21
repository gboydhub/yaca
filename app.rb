require 'sinatra'
require 'mysql2'
require_relative 'database.rb'
require_relative 'users.rb'
enable :sessions

get '/' do
  erb :login
end

post '/create_user' do
  uname = params[:username]
  pass = params[:password]

  new_user = UserAccount.new
  if new_user.create_user(uname, pass) == false
    session[:login_error] = new_user.error
    redirect '/'
  else
    session[:uuid] = new_user.uuid
    redirect '/home'
  end
end

# SELECT CAST(AES_DECRYPT(name, AES_KEY) AS CHAR(50)) FROM `users` WHERE id=1
# SELECT `id` FROM `users` WHERE name=AES_ENCRYPT('testuser', UNHEX(SHA2('Broken Sorceress Hell Cows',512))) AND password=AES_ENCRYPT('testpass', UNHEX(SHA2('Brokeusersn Sorceress Hell Cows',512)))
