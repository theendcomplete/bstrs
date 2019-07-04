# frozen_string_literal: true

require 'cgi'
require 'open-uri'

class RequestResponse < ApplicationRecord
  belongs_to :user
  has_one :captcha
  serialize :params, Hash
  serialize :response, JSON
  enum endpoints: {like_post: 'https://api.vk.com/method/likes.add?',
                   follow_vcommunity: 'https://api.vk.com/method/groups.join?',
                   unfollow_vcommunity: 'https://api.vk.com/method/groups.leave?',
                   check_membership: 'https://api.vk.com/method/groups.isMember?',
                   resolve_screen_name: 'https://api.vk.com/method/utils.resolveScreenName?',
                   invite_to_group: 'https://api.vk.com/method/groups.invite?',
                   post_comment: 'https://api.vk.com/method/wall.createComment?',
                   friends_get: 'https://api.vk.com/method/friends.get?',
                   groups_get_by_id: 'https://api.vk.com/method/groups.getById?',
                   add_vote: 'https://vk.com/dev/polls.addVote?'}

  def request_response_logger
    @@request_response_logger ||= Logger.new("#{Rails.root}/log/request_response.log")
  end

  def self.make_request(action, rr_params = {})
    user = rr_params['usr']

    rr = RequestResponse.new
    rr.params = rr_params
    rr_params['v'] = 5.92
    rr.url = endpoints[action]
    user.request_responses << rr if (user && !user.class == User)
    rr.save
    @result = nil
    if user.class == User && user&.is_valid_vk_user || action == :check_membership
      rr.request_response_logger.info("Sending #{action} request with params: #{rr_params} as #{user}")
      retry_count = 0
      begin
        retry_count += 1
        if retry_count < 3
          @result = URI.parse(rr.url + rr_params.to_h.to_query.to_s).read
          rr.request_response_logger.info(@result.to_s)
        end
      rescue StandardError => e
        # Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        #   Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        rr.request_response_logger.error(e.to_s)
        sleep 10.seconds
        retry
      end
    end
    unless @result.nil?
      rr.update_attribute('response', @result)
      if user && user.class == User
        if JSON.parse(@result).dig('error', 'error_code') == 5
          user.update_attribute('is_valid_vk_user', false)
        elsif JSON.parse(@result).dig('error', 'error_code') == 14 #TODO парсинг капчи будет тут
          captcha = Captcha.new
          captcha.request_params = rr.response
          captcha.captcha_sid = JSON.parse(rr.response).dig('error', 'captcha_sid')
          captcha.captcha_img = JSON.parse(rr.response).dig('error', 'captcha_img')
          #TODO обработка сетевых ошибок
          c_img = open(captcha.captcha_img)
          captcha.image.attach(io: c_img, filename: captcha.captcha_sid)
          captcha.request_response = rr
          rr.captcha = captcha
          captcha.save!
          # rr.save!
        else
          user.update_attribute('is_valid_vk_user', true)
        end
      end
    end
    ActiveRecord::Base.connection.close
    @result
  end
#TODO
# def permitted_params
#   accessible = %i[captcha_sid captcha_key id v] # extend with your own params
#   params.permit(accessible)
# end
end
