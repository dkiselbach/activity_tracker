require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:dylan)
    @user_no_activities = users(:archer)
    @user_no_auths = users(:emily)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "associated activities should be destroyed" do
    @user_no_activities.save
    @user_no_activities.activity.create!(distance: "123", strava_id: "124568")
    assert_difference 'Activity.count', -1 do
      @user_no_activities.destroy
    end
  end

  test "associated auths should be destroyed" do
    @user_no_auths.save
    @user_no_auths.create_auth!(app_name: "Strava", token: "1234")
    assert_difference 'Auth.count', -1 do
      @user_no_auths.destroy
    end
  end
end
