require 'test_helper'

class UserTest < ActiveSupport::TestCase
#include Devise::Test::ControllerHelpers

  test "should not save user without token" do
    user = User.new
    assert_not user.save
  end
  test "user should be saved with token" do
    user = User.new
    user.vk_offline_token = SecureRandom.uuid
    user.email = 'ya@ya.ru'
    user.password = SecureRandom.uuid
    user.password_confirmation = user.password
    user.name = "Johnny"
    # sign_in user
    #  p user.errors.full_messages
    #  p user.save
    assert user.valid?
  end
end
