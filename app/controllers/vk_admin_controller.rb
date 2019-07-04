# frozen_string_literal: true

require 'cgi'
require 'open-uri'
class VkAdminController < ApplicationController
  before_action :check_vk_admin, only: %i[approve_post edit]
  before_action :get_users_and_groups_ids, only: %i[invite_user_friends]


  def like_post
    @users_count = User.all.count
  end

  def make_like
    if current_user.vk_admin?
      what_to_like = params[:q]
      users = User.all.shuffle
      users.each do |u|
        Thread.new do
          LikeVcPostJob.set(wait: rand(5..7).seconds).perform_later(u, what_to_like)
        end
      end
    end
    flash[:success] = 'Likes are on their way'
    redirect_to vk_admin_like_post_path
  end

  def post_comment
    if current_user.vk_admin?
      messages = %w[!!!! атлична-атлична годнота жир Спасибо!]
      what_to_like = params[:q].sub!('https://vk.com/wall', '')
      users = User.all.shuffle
      users.find_each do |u|
        Thread.new do
          PostCommentJob.set(wait: rand(5..720).seconds).perform_later(u, what_to_like, messages.sample)
        end
      end
      flash[:success] = 'Comments are on their way'
    end
    redirect_to vk_admin_like_post_path
  end

  def invite_user
    group_id =  Rails.application.credentials.production[:group][:group_id]
    user = User.find(params[:user_id])
    # InviteUserToGroupJob.set(wait: rand(5..10).seconds).perform_later(user, group_id, current_user.vk_offline_token)
    # response = user.invite_user_to_vcommunity(user.vkid, group_id, current_user&.vk_offline_token)

    # flash[:info] = response
    flash[:info] = 'not yet implemented'

    redirect_to vk_admin_new_users_list_path

  end

  def follow_group
    if current_user.vk_admin?
      User.all.shuffle.find_each do |u|
        Thread.new do
          FollowVcommunityJob.set(wait: rand(5..720).seconds).perform_later(u, params[:q])
        end
      end
    end
    flash[:success] = 'The follow job has been started'
    redirect_to vk_admin_like_post_path
  end

  def create_captcha_objects
    RequestResponse.find_each do |rr|
      if rr.captcha.nil? && !rr.response.to_s.blank?
        if rr.response.is_a?(Hash) #Проверка на тип
          if rr.response.dig('error', 'error_code') == 14
            captcha = Captcha.new
            captcha.request_params = rr.response
            captcha.captcha_sid = rr.response.dig('error', 'captcha_sid')
            captcha.captcha_img = rr.response.dig('error', 'captcha_img')
            #TODO обработка сетевых ошибок
            c_img = open(captcha.captcha_img)
            # c_img = captcha.remove_background(captcha.captcha_img)
            captcha.image.attach(io: c_img, filename: captcha.captcha_sid)
            captcha.request_response = rr
            captcha.save!
          end
        end
      end
    end
    flash[:success] = 'The fill_out_captchajob has been started'
    redirect_to vk_admin_like_post_path
  end

  def invite_user_friends
    if current_user.vk_admin?
      Thread.new do
        User.all.shuffle.each do |u|
          get_friends_params = Hash.new(0)
          get_friends_params['order'] = 'random'
          get_friends_params['access_token'] = u.vk_offline_token
          get_friends_params['count'] = 3000
          get_friends_params['fields'] = 'nickname, city, status'
          get_friends_params['usr'] = u
          get_friends_params['user_id'] = u.vkid

          result = RequestResponse.make_request(:friends_get, get_friends_params)
          result = JSON.parse(result) unless result.nil?
          @friends = result.dig('response', 'items')
          unless @friends.nil?
            @friends.each_with_index do |f, i|
              if @all_users.include? f['id']
                @friends.delete_at(i)
                next
              end
              @all_vcommunities.each do |vcommunity|
                #TODO Колоссальная загрузка БД
                # Оптимизировать в первую очередь
                unless Invite.find_by_group_id_and_invited_id(vcommunity, f['id'])
                  invite = Invite.new
                  invite.user = u
                  invite.invited_id = f['id']
                  invite.group_id = vcommunity
                  invite.planned_time = DateTime.current
                  invite.save!
                end
              end

            end
            seconds_to_wait = rand(0..3)
            limit_reached = false
            user_invites = Invite.where(user: u, sent_at: nil, planned_time: DateTime.current.advance(:years => -1)...DateTime.current)
            user_invites.shuffle.each do |i|
              until limit_reached
                group_id = i.group_id
                user = i.user
                user_to_invite_id = i.invited_id
                sleep(seconds_to_wait)
                result = user.invite_user_to_vcommunity(u, user_to_invite_id, group_id, user.vk_offline_token)
                unless result.nil?
                  if JSON.parse(result).dig('error', 'error_code') == 14 #TODO парсинг капчи
                    i.update_attributes!('planned_time': DateTime.current.advance(:days => 1), 'request_params': result)
                  elsif JSON.parse(result).dig('error', 'error_code') == 15 #Пользователь запретил себя приглашать, удаляем все его инвайты
                    user_invites.each do |ui|
                      if ui.invited_id == i.invited_id
                        i.update_attributes!('sent_at': DateTime.current, 'request_params': result)
                      end
                    end
                  elsif not JSON.parse(result).dig('error', 'error_code').nil?
                    i.update_attributes!('planned_time': DateTime.current.advance(:days => 1), 'request_params': result)
                    limit_reached = true
                  else
                    i.update_attributes!('sent_at': DateTime.current, 'request_params': result)
                  end
                  sleep(rand(1..30).seconds)
                end
              end
            end
          end
        end
      end
      flash[:success] = 'The follow job has been started'
      redirect_to vk_admin_like_post_path
    end
  end

  def unfollow_group
    if current_user.vk_admin
      User.all.shuffle.each do |u|
        Thread.new do
          UnfollowVcommunityJob.set(wait: rand(5..720).seconds).perform_later(u, params[:q])
        end
      end
    end
    flash[:success] = 'The unfollow job has been started'
    redirect_to vk_admin_like_post_path
  end

# @return [Object]
  def approve_user
    us = User.find(params[:format])
    User.all.shuffle.each do |u|
      if u.isBoostersMember
        FollowVcommunityJob.set(wait: rand(5..720).seconds).perform_later(u, us.vcommunities.first)
        FollowVcommunityJob.set(wait: rand(5..720).seconds).perform_later(us, u.vcommunities.first)
      end
    end
    flash[:success] = 'The follow job has been started!'
    redirect_to vk_admin_like_post_path
  end

  def new_users_list
    @new_users = Role.find(1).users
  end

  def new_posts_list
    @new_posts = Post.where(status: 0)
  end

  def preview_link
    @group_html = URI.parse('https://vk.com/theboosters').read
    respond_to do |format|
      format.html {render 'vk_admin/group_preview'}
    end
  end

  private

  def get_users_and_groups_ids

    @all_users = User.all.shuffle.map(&:vkid)
    # @all_vcommunities = Vcommunity.where(community_type: 'event').map(&:vkid)
    @all_vcommunities = Vcommunity.all.shuffle.map(&:vkid)
  end

  def check_vk_admin
    true if current_user.vk_admin
  end

  def uuid
    'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'.gsub('x') do
      rand(16).to_s(16)
    end
  end

end
