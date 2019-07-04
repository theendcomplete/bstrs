class InvitesController < ApplicationController
  @@all_users = User.all.map(&:vkid)

  def index

    get_friends_params = Hash.new(0)
    get_friends_params['order'] = 'random'
    get_friends_params['access_token'] = current_user.vk_offline_token
    get_friends_params['count'] = 1000
    get_friends_params['fields'] = 'nickname, city, status'
    get_friends_params['usr'] = current_user
    get_friends_params['user_id'] = current_user.vkid

    result = JSON.parse(RequestResponse.make_request(:friends_get, get_friends_params))
    @friends = result.dig('response', 'items')
    @friends.each_with_index do |f, i|
      if @@all_users.include? f['id']
        @friends.delete_at(i)
      end
    end
  end

  def send_invite
    group_id = Rails.application.credentials.production[:group][:group_id]
    user = current_user
    response = user.invite_user_to_vcommunity(user, params[:user_id], group_id, current_user.vk_offline_token)
    if JSON.parse(response)['response'] == 1
      flash[:success] = 'Приглашение успешно отправлено'
    elsif JSON.parse(response)['error']
      flash[:error] = JSON.parse(response)['error']['error_text']
    else
      flash[:error] = response
    end
    redirect_to invites_index_path
  end

  def create_invite
  end
end
