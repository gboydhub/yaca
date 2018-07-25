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
    pre_connect()
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
          @uuid = id
          return true
        end
      end
    end
    @db.close()
    return false
  end

  def add_new_contact(name, phone, address, zip, notes)
    unless uuid_valid?(@uuid)
      @error = "Invalid USER"
      return false
    end

    pre_connect()
    if @db.is_active?()
      name = clean_string(name)
      phone = clean_string(phone)
      address = clean_string(address)
      zip = clean_string(zip)
      notes = clean_string(notes)

      @db.client.query("INSERT INTO `contacts` (name, phone, address, zip, notes, owner) VALUES ('#{name}', '#{phone}', '#{address}', '#{zip}', '#{notes}', '#{@uuid}')")
      return true
    end
    @error = "Error connecting to Database"
    false
  end

  def get_contacts()
    unless uuid_valid?(@uuid)
      @error = "Invalid USER"
      return false
    end

    pre_connect()
    if @db.is_active?()
      ret_arr = []
      result = @db.client.query("SELECT * FROM `contacts` WHERE owner='#{@uuid}'", :symbolize_keys => true)
      result.each do |row|
        ret_arr << row
      end
      return ret_arr
    end
    @error = "Error connecting to Database"
    false
  end

  def contact_update_field(contactid, fieldname, value)
    unless uuid_valid?(@uuid)
      @error = "Invalid USER"
      return false
    end

    pre_connect()
    if @db.is_active?()
      fieldname = clean_string(fieldname)
      value = clean_string(value)
      contactid = clean_string(contactid)

      @db.client.query("UPDATE `contacts` SET `#{fieldname}`='#{value}' WHERE id='#{contactid}' AND owner='#{@uuid}'")
      return true
    end
    @error = "Error connecting to database"
    false
  end

  attr_reader :error
  attr_reader :uuid
end