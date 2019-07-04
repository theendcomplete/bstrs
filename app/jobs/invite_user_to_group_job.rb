# frozen_string_literal: true

class InviteUserToGroupJob < ApplicationJob
  queue_as :default

  def perform(user, vcommunity_id, admin_token)
    user.invite_user_to_vcommunity(user, vcommunity_id, admin_token)
  end
end
