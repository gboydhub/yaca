require_relative 'database.rb'
require 'sanitize'

class UserAccount
  def initialize
    @db = DataBase.new
    @error = ''
    @uuid = ''
  end

  def create_user(name, pass)
    @db.connect()
    if @db.is_active?()
      name = Sanitize.clean(name)
      pass = Sanitize.clean(pass)
      name = @db.client.escape(name)
      pass = @db.client.escape(pass)
      result = @db.client.query("SELECT `user_id` FROM `users` WHERE name=AES_ENCRYPT('#{name}', #{ENV['AES_KEY']})", :symbolize_keys => true)
      result.each do |row|
        @error = 'User already exists'
        return false
      end
      @db.client.query("INSERT INTO users (`name`, `password`, `user_id`) VALUES (AES_ENCRYPT('#{name}', #{ENV['AES_KEY']}), AES_ENCRYPT('#{pass}', #{ENV['AES_KEY']}), UUID())", :symbolize_keys => true)
      
      @result = @db.client.query("SELECT `user_id` FROM `users` WHERE name=AES_ENCRYPT('#{name}', #{ENV['AES_KEY']}) AND password=AES_ENCRYPT('#{pass}', #{ENV['AES_KEY']})", :symbolize_keys => true)
      result.each do |row|
        if row[:user_id].length > 0
          @uuid = row[:user_id]
        else
          @db.close()
          @error = 'Could not create account'
          return false
        end
      end
      @db.close()
      return true
    end

    @error = 'Error connecting to database'
    false
  end

  def uuid_valid?(id)
    @db.connect()
    if @db.is_active?()
      id = Sanitize.clean(id)
      id = @db.client.escape(id)

      result = @db.client.query("SELECT `user_id` FROM `users` WHERE user_id='#{id}'")
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