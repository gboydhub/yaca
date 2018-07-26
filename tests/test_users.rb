require 'minitest/autorun'
require_relative '../users.rb'

class TestUserAccount < Minitest::Test

  def setup
    @test_user = UserAccount.new
    @contact_id = -1
    assert_equal(true, @test_user.valid_account?('randomacc', 'somepass'))
    #Have to do this on setup or other tests break because no valid user ID
  end
  def test_assert_1_equals_1
    assert_equal(1, 1)
  end

  def test_new_user
    assert_equal(false, @test_user.create_user('randomacc', 'somepass')) #False because generated on first test
  end

  def test_valid_user
    assert_equal(true, @test_user.valid_account?('randomacc', 'somepass'))
    uuid = @test_user.uuid
    assert_equal(true, @test_user.uuid_valid?(uuid))
  end

  def test_invalid_user
    bad_user = UserAccount.new
    assert_equal(false, bad_user.valid_account?('giberish', 'asd'))
    assert_equal(false, bad_user.uuid_valid?('123'))
  end

  def test_clean_string
    assert_equal("hi", @test_user.clean_string("hi"))
    assert_equal("hi\\'", @test_user.clean_string("hi'"))
    assert_equal("hi", @test_user.clean_string("<b>hi"))
  end

  def test_add_contact
    @contact_id = @test_user.add_new_contact("Jeremy Tong", "555-5555", "123 Lane Street", "25635", "Instructor at Mined Minds.")
    refute_equal(-1, @contact_id)
  end

  def test_get_contacts
    assert_equal(Array, @test_user.get_contacts().class)
  end

  def test_update_contact
    assert_equal(true, @test_user.contact_update_field(@contact_id.to_s, 'name', 'Somebody'))
  end

  def test_delete_contact
    assert_equal(true, @test_user.delete_contact(@contact_id))
  end
end