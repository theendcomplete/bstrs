# frozen_string_literal: true

class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    user.admin? || user.isBoostersMember || (post.user_id == user.user_id)
  end

  def create?
    user.admin? || user.isBoostersMember || (post.user_id == user.user_id)
  end

  def show?
    user.admin? || (post.user_id == user.user_id)
  end

  def edit?
    user.admin? || (post.user_id == user.user_id)
  end

  def update_status?
    user.admin? || (post.user_id == user.user_id)
  end
end
