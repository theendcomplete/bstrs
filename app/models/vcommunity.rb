# frozen_string_literal: true

class Vcommunity < ApplicationRecord
  has_and_belongs_to_many :users
  # enum community_type: [group: "group",
  #                       page: "page",
  #                       event: "event"]
  URL_REGEXP = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix

  validates_presence_of :vkid
  validates_presence_of :address, message: 'Сообщество не найдено :('

  def self.find_or_create_by_addr(user, vk_c, *additional_params)
    if Vcommunity.find_by_address(vk_c)
      community = Vcommunity.find_by_address(vk_c)
    else
      unless vk_c.blank?
        community = Vcommunity.new
        community.address = vk_c
        community_search_params = Hash.new(0)
        unless user == nil
          community_search_params['usr'] = user
        end
        unless additional_params.empty?
          additional_params[0][:usr]
        end
        community_search_params['screen_name'] = vk_c.sub('https://vk.com/', '')
        #  Rails.application.credentials.production[:group][:access_token]
        if user&.is_valid_vk_user && user&.vk_offline_token != '0' && !user&.vk_offline_token.blank?
          community_search_params['access_token'] = user.vk_offline_token
        else
          #TODO вынести в env
          community_search_params['access_token'] =  Rails.application.credentials.production[:group][:access_token]
        end
        # community_search_params['access_token'] = user.vk_offline_token

        result = RequestResponse.make_request(:resolve_screen_name,
                                              community_search_params)
        if not result.nil? && JSON.parse(result)['response']
          unless community.address.blank?
            community.name = vk_c.sub('https://vk.com/', '')
            json = JSON.parse(result)
            community.vkid = json.dig('response', 'object_id')
            community.community_type = json.dig('response', 'type')
            community_info_params = Hash.new(0)
            community_info_params['group_id'] = community.vkid
            community_info_params['access_token'] = user.vk_offline_token
            community_info_params['fields'] = 'city, country, place, description, wiki_page, market, members_count, counters, start_date, finish_date, can_post, can_see_all_posts, activity, status, contacts, links, fixed_post, verified, site, ban_info, cover'
            if user.class == User && user&.is_valid_vk_user
              community_info_params['usr'] = user
            else
              community_info_params['usr'] = additional_params[0][:usr] unless additional_params.empty?
            end
            community_info = RequestResponse.make_request(:groups_get_by_id,
                                                          community_info_params)
            if not community_info.nil?
              community_info = JSON.parse(community_info)
            end
            if not community_info.nil?
              community.update_attributes!('name': community_info.dig('response', 0, 'name'),
                                           'city': community_info.dig("response", 0, 'city', 'title'))
            else
              community.save!
            end
          end
        end
      end
    end
    community
  end

  def self.show_collection_as_string(vcommunities)
    array = []
    vcommunities.each do |vcom|
      array << vcom.name
    end
    array
  end

  def self.find_id_by_address(address)
    community_search_params = Hash.new(0)
    community_search_params['screen_name'] = address.sub('https://vk.com/', '')
    community_search_params['access_token'] = user.vk_offline_token
    community_search_params['v'] = 5.92
    vkid = ''
    url = URI.parse("https://api.vk.com/method/utils.resolveScreenName?#{community_search_params.to_query}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    begin
      resp, data = Net::HTTP.post(url, data)
      # TODO: real community name
      unless address.blank?
        json = JSON.parse(resp.body)
        vkid = json.dig('response', 'object_id')
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      flash[:error] = e.to_s
      retry
    end
    vkid
  end

  def to_s
    name
  end
end
