require 'minitest/autorun'
require_relative '../database.rb'

class TestDatabase < Minitest::Test
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

  def test_db_client_query
    db = DataBase.new
    db.connect(ENV['RDS_DB_NAME'], ENV['RDS_HOSTNAME'], ENV['RDS_PORT'], ENV['RDS_USERNAME'], ENV['RDS_PASSWORD'])

    result = db.client.query("SELECT CHARSET('abc')")
    assert_equal("utf8", result.first["CHARSET('abc')"])
    db.close()
  end

  def test_db_quick_connect
    db = DataBase.new
    db.connect()
    assert_equal(true, db.is_active?())
    db.close()
  end
end