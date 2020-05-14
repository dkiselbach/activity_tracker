require 'test_helper'

class ActivityControllerTest < ActionDispatch::IntegrationTest
  test "should get sync" do
    get activity_sync_url
    assert_response :success
  end

end
