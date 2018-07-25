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

  def test_add_contact
    test_user = UserAccount.new
    assert_equal(true, test_user.valid_account?('randomacc', 'somepass'))
    #assert_equal(7, test_user.add_new_contact("Jeremy Tong", "555-5555", "123 Lane Street", "25635", "Instructor at Mined Minds."))
  end

  def test_get_contacts
    test_user = UserAccount.new
    assert_equal(true, test_user.valid_account?('randomacc', 'somepass'))
    test_user.get_contacts()
  end

  def test_update_contact
    test_user = UserAccount.new
    assert_equal(true, test_user.valid_account?('randomacc', 'somepass'))
    assert_equal(true, test_user.contact_update_field('2', 'name', 'Somebody'))
  end
end