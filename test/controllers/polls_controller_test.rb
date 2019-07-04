require 'test_helper'

class PollsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get polls_create_url
    assert_response :success
  end

  test "should get new" do
    get polls_new_url
    assert_response :success
  end

  test "should get index" do
    get polls_index_url
    assert_response :success
  end

end
