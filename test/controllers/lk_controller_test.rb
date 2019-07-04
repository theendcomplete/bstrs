require 'test_helper'

class LkControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get lk_index_url
    assert_response :success
  end

  test "should get vk" do
    get lk_vk_url
    assert_response :success
  end

end
