# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %{
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          check_membership
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  %i[twitter facebook vkontakte].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(user)
    # if resource.email_verified?
    # if User.check_user_vk_membership(current_user)
    #   redirect_to root_path
    # else
    #   current_user.vk_offline_token = '0'
    #   current_user.save
    #   redirect_to finish_signup_path(current_user)
    # end
    if user.vk_offline_token == '0' || user.vk_offline_token.blank?
      # super resource
      finish_signup_path(user)
    else
      root_path

      # if User.check_user_vk_membership(current_user)
      #   # TODO refak
      #   User.approve_user(current_user)
      #   User.all.shuffle.each do |u|
      #     FollowVcommunityJob.set(wait: rand(5..720).seconds).perform_later(u, current_user.vcommunities.first)
      #     FollowVcommunityJob.set(wait: rand(5..720).seconds).perform_later(current_user, u.vcommunities.first)
      #     # end
      #     root_path
      #   else
      #     super resource
      #     # finish_signup_path(resource)
      #   end
      # end
    end
  end

  def check_membership
    if User.check_user_vk_membership(current_user)
      current_user.update_attributes(isBoostersMember: true)
      User.approve_user(current_user)
      User.all.shuffle.each do |u|
        FollowVcommunityJob.set(wait: rand(5..720).seconds).perform_later(u, current_user.vcommunities.first)
        FollowVcommunityJob.set(wait: rand(5..720).seconds).perform_later(current_user, u.vcommunities.first)
        root_path
      end
    else
      current_user.update_attributes(isBoostersMember: false)
      welcome_registered_path
    end
  end
end
