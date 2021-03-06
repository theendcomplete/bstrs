# frozen_string_literal: true

require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers
  test 'should get index' do
    get welcome_index_url
    assert_response :success
  end

  test 'unlogged user should be redirected' do
    get welcome_registered_url
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h4', 'Для того, чтобы присоединиться к сообществу, войдите с помощью своего аккаунта вконтакте'
  end

#   test 'signed in user not in boosters should see his page' do
#     @user = User.new
#     [{name: 'New user'}, {name: 'the checked one'}].each do |el|
#       role = Role.new
#       # p el
#       role.name = el[:name]
#       role.save!
#     end
# <<<<<<< HEAD
#     # p Role.all
#     @user.roles << Role.all.last
#     @user.isBoostersMember = true
#     # sign_in @user
#     login_as @user
#     get welcome_index_url
#     follow_redirect!
# =======
#     @user.isBoostersMember = true
#     @user.roles << Role.all.last
#     @user.vkid = 123456
#     sign_in @user
#     get welcome_index_url
# #    follow_redirect!
#     #assert_response :success
#     assert_select 'h4', 'Для того, чтобы присоединиться к сообществу, войдите с помощью своего аккаунта вконтакте'
# #     assert_select 'p', 'Заявка отправлена на модерацию, <%= current_user&.name %>.'
#   end
end
