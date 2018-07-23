require 'sinatra'
require 'mysql2'
require_relative 'database.rb'
require_relative 'users.rb'
enable :sessions

get '/' do
  session[:login_error] = ''
  erb :login
end

get '/issue' do
  error = session[:login_error] || ''
  erb :login, locals: {error_msg: error}
end

get '/home' do
  "You made it through!<br>Your UUID: #{session[:uuid]}"
end

post '/login' do
  new_user = UserAccount.new
  uname = new_user.clean_string(params[:username])
  pass = new_user.clean_string(params[:password])
  confirm_pass = new_user.clean_string(params[:confirm])
  puts "Confirm: #{confirm_pass}"
  
  if params[:logintype] == "Sign Up"    # Trigger create new-user
    if confirm_pass == pass     # Password Matches
      if new_user.create_user(uname, pass) == false # Error creating account
        session[:login_error] = new_user.error
        redirect '/issue'
      else
        session[:uuid] = new_user.uuid  # Created account, login
        redirect '/home'
      end
    else  # Password does not match
      session[:login_error] = 'Password mis-match'
      redirect '/issue'
    end

  else    # Trigger login attempt
    if new_user.valid_account?(uname, pass) == false  # Invalid login
      session[:login_error] = new_user.error
      redirect '/issue'
    else  # Valid Login
      session[:uuid] = new_user.uuid  
      redirect '/home'
    end
  end
end