require 'minitest/autorun'
require_relative '../db.rb'
if File.exist?('../local_env.rb')
  require_relative '../local_env.rb'
end

class TestDb < Minitest::Test
  def test_assert_1_equals_1
    assert_equal(1, 1)
  end

  def test_db_connect
    db = DataBase.new
    assert_equal(false, db.is_active?())

    db.connect(ENV['RDS_DB_NAME'], ENV['RDS_HOSTNAME'], ENV['RDS_PORT'], ENV['RDS_USERNAME'], ENV['RDS_PASSWORD'])
    assert_equal(true, db.is_active?())
    
    db.close()
    assert_equal(false, db.is_active?())
  end
end