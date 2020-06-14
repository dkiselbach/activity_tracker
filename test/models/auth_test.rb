require 'test_helper'

class AuthTest < ActiveSupport::TestCase
  def setup
    @user = users(:dylan)
    @auth = @user.build_auth(app_name: "Strava", token: "1234")
  end

  test "should be valid" do
    assert @auth.valid?
  end

  test "user id should be present" do
    @auth.user_id = nil
    assert_not @auth.valid?
  end

  test "token should be present" do
    @auth.token = "   "
    assert_not @auth.valid?
  end

  test "should delete if users destroyed" do
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @auth.reload }
  end
end
