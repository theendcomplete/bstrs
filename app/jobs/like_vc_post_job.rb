class LikeVcPostJob < ApplicationJob
  queue_as :default

  def perform(user, post)
    user.like_post(user, post)
  end
end
