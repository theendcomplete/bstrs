require 'test_helper'

class InvitesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get invites_index_url
    assert_response :success
  end

  test "should get send_invite" do
    get invites_send_invite_url
    assert_response :success
  end

  test "should get create_invite" do
    get invites_create_invite_url
    assert_response :success
  end

end
