require 'minitest/autorun'
require_relative '../users.rb'

class TestUserAccount < Minitest::Test
  def test_assert_1_equals_1
    assert_equal(1, 1)
  end

  def test_new_user
    test_user = UserAccount.new
    assert_equal(false, test_user.create_user('randomacc', 'somepass'))
  end

  def test_valid_user
    test_user = UserAccount.new
    assert_equal(true, test_user.valid_account?('randomacc', 'somepass'))
    uuid = test_user.uuid
    assert_equal(true, test_user.uuid_valid?(uuid))
  end

  def test_invalid_user
    test_user = UserAccount.new
    assert_equal(false, test_user.valid_account?('giberish', 'asd'))
    assert_equal(false, test_user.uuid_valid?('123'))
  end

  def test_clean_string
    test_user = UserAccount.new
    assert_equal("hi", test_user.clean_string("hi"))
    assert_equal("hi\\'", test_user.clean_string("hi'"))
    assert_equal("hi", test_user.clean_string("<b>hi"))
  end
end