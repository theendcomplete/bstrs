# frozen_string_literal: true
require 'cgi'
require 'open-uri'
class WelcomeController < ApplicationController
  def index
    if current_user&.roles&.include?(Role.all.first)
      redirect_to welcome_registered_path
    end
    # redirect_to welcome_registered_path
  end

  def registered
    if current_user
      current_user.isBoostersMember = User.check_user_vk_membership(current_user)
      current_user.save
    else
      redirect_to welcome_index_path
    end
  end

  # def check_user_vk_membership(user)
  #   User.check_user_vk_membership(user)
  # end
end
