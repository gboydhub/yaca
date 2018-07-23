require 'mysql2'
if File.exist?('local_env.rb')
  require_relative 'local_env.rb'
end

class DataBase
  def initialize
    @db_name = ''
    @db_host = ''
    @db_port = ''
    @db_uname = ''
    @db_pass = ''
    @client = nil
  end

  def connect(dbname=ENV['RDS_DB_NAME'], host=ENV['RDS_HOSTNAME'], port=ENV['RDS_PORT'], uname=ENV['RDS_USERNAME'], pass=ENV['RDS_PASSWORD'])
    @db_name = dbname
    @db_host = host
    @db_port = port
    @db_uname = uname
    @db_pass = pass
    p ENV['INSTANCE_LOC']
    @client = Mysql2::Client.new(:host => host, :username => uname, :password => pass, :port => port, database: dbname)
  end

  def close
    @client.close()
    @client = nil
  end

  def is_active?
    if @client == nil
      return false
    end
    true
  end

  attr_reader :client
end