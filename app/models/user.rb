# frozen_string_literal: true

require 'cgi'
require 'open-uri'

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_and_belongs_to_many :vcommunities
  has_and_belongs_to_many :roles
  has_many :posts
  has_many :request_responses
  has_many :invites
  # validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update
  validates_uniqueness_of :vk_offline_token, allow_blank: true, allow_nil: true

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Получить identity пользователя, если он уже существует
    identity = Identity.find_for_oauth(auth)

    # Если signed_in_resource предоставлен, он всегда переписывает существующего пользователя,
    # чтобы identity не была закрыта случайно созданным аккаунтом.
    # Заметьте, что это может оставить зомби-аккаунты (без прикрепленной identity)
    # которые позже могут быть удалены
    user = signed_in_resource || identity.user

    # Создать пользователя, если нужно
    if user.nil?
      # Получить email пользователя, если его предоставляет провайдер
      # Если email не был предоставлен мы даем пользователю временный и просим
      # пользователя установить и подтвердить новый в следующим шаге через UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email

      # Создать пользователя, если это новая запись
      if user.nil?
        user = User.new(
            # name: auth.extra.raw_info.name,
            name: auth.extra.raw_info.first_name + ' ' + auth.extra.raw_info.last_name,
            # username: auth.info.nickname || auth.uid,
            email: email || "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            vkid: auth.uid,
            password: Devise.friendly_token[0, 20]
        )
        user.roles << Role&.all&.first if user&.roles&.empty? && !Role.all.empty?
        user.is_admin = true if User.all.count == 0
        user.skip_confirmation!
        user.save!
      end
    end
    user.is_valid_vk_user = true
    user.vkid = auth.uid if user.vkid.nil?
    # Связать identity с пользователем, если необходимо
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def self.add_vkcommunity_to_user(usr, vcommunity)
    # В случае, если юзер уже пиарит сообщество
    # еще одно он добавить не сможет из интерфейса
    # TODO убедиться, что не дыра
    if usr.vcommunities.empty? && !vcommunity.nil?
      usr.vcommunities << vcommunity
    end
    usr.save!
  end

  def my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/user.log")
  end

  def follow_vcommunity(usr, vcommunity)
    what_to_follow_params = Hash.new(0)
    what_to_follow_params['group_id'] = vcommunity
    what_to_follow_params['access_token'] = usr.vk_offline_token
    what_to_follow_params['usr'] = usr
    RequestResponse.make_request(:follow_vcommunity, what_to_follow_params)
  end

  def invite_user_to_vcommunity(usr, user_id_to_invite, vcommunity_id, admin_token)
    invite_params = Hash.new(0)
    invite_params['group_id'] = vcommunity_id
    invite_params['user_id'] = user_id_to_invite
    invite_params['access_token'] = admin_token
    invite_params['usr'] = usr
    RequestResponse.make_request(:invite_to_group, invite_params)
  end

  def like_post(usr, post)
    what_to_like = post.split('wall').last.split('_')
    like_post_params = Hash.new(0)
    like_post_params['type'] = 'post'
    like_post_params['owner_id'] = what_to_like[0]
    like_post_params['item_id'] = what_to_like[1]
    like_post_params['access_token'] = usr.vk_offline_token
    like_post_params['usr'] = usr
    RequestResponse.make_request(:like_post, like_post_params)
  end

  def post_comment(usr, post, message)
    # users = User.all.shuffle
    # messages = %w(!!!! атлична-атлична годнота жир Спасибо!)
    where_to_post = post
    post_comment_params = Hash.new(0)
    post_comment_params['type'] = 'post'
    post_comment_params['message'] = message
    post_comment_params['guid'] = SecureRandom.uuid
    post_comment_params['owner_id'] = where_to_post.split('_')[0]
    post_comment_params['post_id'] = where_to_post.split('_')[1]
    post_comment_params['access_token'] = usr&.vk_offline_token
    post_comment_params['usr'] = usr
    RequestResponse.make_request(:post_comment, post_comment_params)
  end

  def unfollow_vcommunity(u, vcommunity)
    what_to_leave_params = Hash.new(0)
    what_to_leave_params['group_id'] = vcommunity
    what_to_leave_params['access_token'] = u.vk_offline_token
    what_to_leave_params['usr'] = u
    RequestResponse.make_request(:unfollow_vcommunity, what_to_leave_params)
  end

  # TODO: вывести в env
  def self.check_user_vk_membership(user, group_id = Rails.application.credentials.production[:group][:group_id], a_token = Rails.application.credentials.production[:group][:a_token])
    check_membership_params = Hash.new(0)
    check_membership_params['group_id'] = group_id
    check_membership_params['user_id'] = user.vkid
    check_membership_params['usr'] = user
    check_membership_params['access_token'] = a_token
    result = RequestResponse.make_request(:check_membership,
                                          check_membership_params)
    if !result.nil? && JSON.parse(result)['response']
      return true
    else
      return false
    end
  end

  def self.approve_user(us)
    us.roles.delete(Role.find(1))
    us.roles << Role.find(2)
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end
end
