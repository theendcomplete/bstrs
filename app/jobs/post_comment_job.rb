class PostCommentJob < ApplicationJob
  queue_as :default

  def perform(user, post, message)
    user.post_comment(user, post, message)
  end
end