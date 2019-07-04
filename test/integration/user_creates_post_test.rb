# frozen_string_literal: true

require 'test_helper'

class UserCreatesPostTest < ActionDispatch::IntegrationTest
  # test 'Guest can see the welcome page' do
  #   get '/'
  #   assert_select 'h4', 'Для того, чтобы присоединиться к сообществу, войдите с помощью своего аккаунта вконтакте'
  # end
  #
  # test 'Guest can not see the posts page' do
  #   get '/post/index'
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_response :success
  #   assert_select 'h4', 'Для того, чтобы присоединиться к сообществу, войдите с помощью своего аккаунта вконтакте'
  # end
  # test "User can see the posts page" do
  #   get "/posts"
  #   assert_select "h4", "Продвинуть новый пост:"
  # end
end
