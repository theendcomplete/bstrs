require 'test_helper'

class CaptchaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get captcha_index_url
    assert_response :success
  end

  test "should get solve" do
    get captcha_solve_url
    assert_response :success
  end

end
