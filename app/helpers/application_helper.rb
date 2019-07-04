# frozen_string_literal: true

module ApplicationHelper
  # def check_user_vk_membership(user_id, group_id =  Rails.application.credentials.production[:group][:group_id])
  #   check_membership_params = Hash.new(0)
  #   check_membership_params['group_id'] = group_id
  #   check_membership_params['user_id'] = user_id
  #   check_membership_params['v'] = 5.85
  #   check_membership_params['access_token'] = ' Rails.application.credentials.production[:group][:a_token]'
  #   # my_logger.info("Sending follow request with params: #{what_to_follow_params.inspect} as #{usr.name}")
  #   result = URI.parse("https://api.vk.com/method/groups.isMember?#{check_membership_params.to_query}").read
  #   # my_logger.info(result.inspect.to_s)
  #   p result
  #   ActiveRecord::Base.connection.close
  # end
end
