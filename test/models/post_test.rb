require 'test_helper'

class PostTest < ActiveSupport::TestCase

  test "should not save post without name" do
    post = Post.new
    post.address = 'https://vk.com/wall-171596046_46'
    user = User.new
    user.posts << post
    assert_not post.save, "Saved the post without name"
  end

  test "should not save post without address" do
    post = Post.new
    post.address = 'https://vk.com/wall-171596046_46'
    user = User.new
    user.posts << post
    assert_not post.save, "Saved the post without address"
  end

  test "should save post with address and name" do
    user = User.new
    post = Post.new
    post.name = 'test_name'
    post.address = 'https://vk.com/wall-171596046_46'
    user.posts << post
    # p post.errors.full_messages
    assert post.save, "Didn't save the post with address and name"
  end

  test "should not save post with wrong url" do
    post = Post.new
    post.address = 'test_name'
    user = User.new
    user.posts << post
    assert_not post.save, "Saved the post without address"
  end

  test "should not save post without user" do
    post = Post.new
    post.address = 'test_name'
    assert_not post.save, "Saved the post without user"
  end
end
