require_relative 'database.rb'
require 'sanitize'

class UserAccount
  def initialize
    @db = DataBase.new
    @error = ''
    @uuid = ''
    pre_connect()
  end

  def clean_string(str)
    str = Sanitize.clean(str)
    str = @db.client.escape(str)
  end

  def pre_connect()
    unless @db.is_active?()
      @db.connect()
    end
  end

  def create_user(name, pass)
    pre_connect()
    if @db.is_active?()
      name = clean_string(name)
      pass = clean_string(pass)

      result = @db.client.query("SELECT `user_id` FROM `users` WHERE name=AES_ENCRYPT('#{name}', #{ENV['AES_KEY']})", :symbolize_keys => true)
      result.each do |row|
        @error = 'User already exists'
        return false
      end
      @db.client.query("INSERT INTO users (`name`, `password`, `user_id`) VALUES (AES_ENCRYPT('#{name}', #{ENV['AES_KEY']}), AES_ENCRYPT('#{pass}', #{ENV['AES_KEY']}), UUID())", :symbolize_keys => true)
      
      if valid_account?(name, pass)
        return true
      end

      @error = 'Could not create account'
    end

    @error = 'Error connecting to database'
    false
  end

  def valid_account?(name, pass)
    pre_connect()
    if @db.is_active?()
      name = clean_string(name)
      pass = clean_string(pass)

      result = @db.client.query("SELECT `user_id` FROM `users` WHERE name=AES_ENCRYPT('#{name}', #{ENV['AES_KEY']}) AND password=AES_ENCRYPT('#{pass}', #{ENV['AES_KEY']})", :symbolize_keys => true)
      result.each do |row|
        @uuid = row[:user_id]
        if @uuid.length > 0
          return true
        end
      end
      @error = 'Invalid Username or Password'
      return false
    end
    @error = 'Error connecting to database'
    return false
  end

  def uuid_valid?(id)
    pre_connect()
    if @db.is_active?()
      id = clean_string(id)

      result = @db.client.query("SELECT `user_id` FROM `users` WHERE user_id='#{id}'", :symbolize_keys => true)
      result.each do |row|
        if row[:user_id] == id
          @db.close()
          return true
        end
      end
    end
    @db.close()
    return false
  end

  attr_reader :error
  attr_reader :uuid
end