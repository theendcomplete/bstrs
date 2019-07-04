class FollowVcommunityJob < ApplicationJob
  queue_as :default

  def perform(user, community)
    user.follow_vcommunity(user, community.vkid)
  end
end
