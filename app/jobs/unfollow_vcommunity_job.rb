class UnfollowVcommunityJob < ApplicationJob
  queue_as :default

  def perform(user, community)
    user.unfollow_vcommunity(user, community)
  end
end
