# frozen_string_literal: true
require "awesome_print"
class Post < ApplicationRecord
  validates :name, presence: {message: "Укажите тему поста!"}
  validates :address, presence: {message: "Укажите ссылку на пост!"}
  validates :address, post_url: {message: "Правильная выглядит так: 'https://vk.com/wall*******_**' !"}
  validates :address, uniqueness: {message: "Пост уже был обработан ранее!", case_sensitive: false}
  belongs_to :user
  attr_accessor :likes
  attr_accessor :comments

  def self.update_status(post, status)
    post.status = status
  end

  def self.get_likes(url, a_token = Rails.application.credentials.production[:group][:a_token])
    owner_item = url.split('wall').last.split('_')
    get_likes_params = Hash.new(0)
    get_likes_params['type'] = 'post'
    get_likes_params['owner_id'] = owner_item[0].to_i
    get_likes_params['item_id'] = owner_item[1].to_i
    get_likes_params['filter'] = 'likes'
    get_likes_params['friends_only'] = '0'
    get_likes_params['v'] = 5.92
    get_likes_params['access_token'] = a_token
    result = URI.parse("https://api.vk.com/method/likes.getList?#{get_likes_params.to_query}").read
    ap result
    if JSON.parse(result)['response']
      count = JSON.parse(result)['response']['count']
      if count.nil?
        return 'Ошибка'
      else
        return count
      end
    end
    # JSON.parse(result)['error']['error_msg'].to_s
  end

  def self.get_comments(url, a_token =  Rails.application.credentials.production[:group][:a_token])
    owner_item = url.split('wall').last.split('_')
    get_likes_params = Hash.new(0)
    p owner_item
    # get_likes_params['type'] = 'post'
    get_likes_params['owner_id'] = owner_item[0].to_i
    get_likes_params['post_id'] = owner_item[1].to_i
    get_likes_params['need_likes'] = true
    # get_likes_params['filter'] = 'likes'
    # get_likes_params['friends_only'] = '0'
    get_likes_params['thread_items_count'] = 0
    get_likes_params['v'] = 5.92
    get_likes_params['access_token'] = a_token
    result = URI.parse("https://api.vk.com/method/wall.getComments?#{get_likes_params.to_query}").read
    ap result, :indent => -2
    if JSON.parse(result)['response']
      count = JSON.parse(result)['response']['count']
      # //TODO пофиксить лайки
      # likes = JSON.parse(result)['response']['items']
      # likes = JSON.parse(result).dig(:response, :items, :likes, :count)
      # ap likes
      if count.nil?
        return 'Ошибка'
      else
        return count
        # return count, likes
      end
    end
    # JSON.parse(result)['error']['error_msg'].to_s
  end
end
