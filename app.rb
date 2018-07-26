require 'sinatra'
require 'mysql2'
require_relative 'database.rb'
require_relative 'users.rb'
enable :sessions

get '/' do
  session[:login_error] = ''
  check_user = UserAccount.new
  if check_user.uuid_valid?(session[:uuid])
    redirect '/home'
  end

  erb :login
end

get '/issue' do
  error = session[:login_error] || ''
  erb :login, locals: {error_msg: error}
end

post '/view' do
  viewing = params['view'] || '-1'
  session[:viewing] = viewing
  unless params['delete'] == nil
    session[:viewing] = '-1'
    
    cur_user = UserAccount.new
    unless cur_user.uuid_valid?(session[:uuid])
      redirect '/'
    end
    del_id = cur_user.clean_string(params['delete'])
    cur_user.delete_contact(del_id)
  end
  puts "Params: #{params}"
  redirect '/home'
end

post '/logout' do
  session[:uuid] = ''
  redirect '/'
end

post '/new' do
  redirect '/new'
end

get '/new' do
  cur_user = UserAccount.new
  unless cur_user.uuid_valid?(session[:uuid])
    redirect '/'
  end

  contact_list = cur_user.get_contacts()
  erb :new, locals: {contacts: contact_list}
end

post '/add_contact' do
  cur_user = UserAccount.new
  unless cur_user.uuid_valid?(session[:uuid])
    redirect '/'
  end

  name = cur_user.clean_string(params['contact-name'])
  phone = cur_user.clean_string(params['contact-phone'])
  addr = cur_user.clean_string(params['contact-address'])
  zip = cur_user.clean_string(params['contact-zip'])
  notes = cur_user.clean_string(params['contact-notes'])

  contact_id = cur_user.add_new_contact(name, phone, addr, zip, notes)
  if contact_id
    session[:viewing] = contact_id.to_s
  end

  redirect '/home'
end

post '/edit_contact' do
  cur_user = UserAccount.new
  unless cur_user.uuid_valid?(session[:uuid])
    redirect '/'
  end

  unless params['save']
    redirect '/home'
  end

  contact_id = cur_user.clean_string(params['save'])
  if params['contact-name']
    name = cur_user.clean_string(params['contact-name'])
    if name.length >= 1
      cur_user.contact_update_field(contact_id, 'name', name)
    end
  end

  if params['contact-phone']
    phone = cur_user.clean_string(params['contact-phone'])
    cur_user.contact_update_field(contact_id, 'phone', phone)
  end

  if params['contact-address']
    addr = cur_user.clean_string(params['contact-address'])
    cur_user.contact_update_field(contact_id, 'address', addr)
  end

  if params['contact-zip']
    zip = cur_user.clean_string(params['contact-zip'])
    cur_user.contact_update_field(contact_id, 'zip', zip)
  end

  if params['contact-notes']
    notes = cur_user.clean_string(params['contact-notes'])
    cur_user.contact_update_field(contact_id, 'notes', notes)
  end

  redirect '/home'
end

get '/home' do
  cur_user = UserAccount.new
  unless cur_user.uuid_valid?(session[:uuid])
    redirect '/'
  end
  contact_list = cur_user.get_contacts()
  viewing = session[:viewing] || '-1'
  erb :home, locals: {contacts: contact_list, current_view: viewing}
end

post '/login' do
  new_user = UserAccount.new
  uname = params[:username]
  pass = params[:password]
  confirm_pass = new_user.clean_string(params[:confirm])
  puts "Confirm: #{confirm_pass}"

  unless uname == new_user.clean_string(uname) && pass == new_user.clean_string(pass)
    session[:login_error] = 'Invalid username or password<br>Please only include standard characters.'
    redirect '/issue'
  end
  
  uname = new_user.clean_string(uname)
  pass = new_user.clean_string(pass)

  if uname.length < 4 || uname.length > 12
    session[:login_error] = 'Username must be between 4 and 12 characters.'
    redirect '/issue'
  end
  if pass.length < 4 || pass.length > 16
    session[:login_error] = 'Password must be between 4 and 16 characters.'
    redirect '/issue'
  end
  
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