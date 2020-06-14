require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  def setup
    @user = users(:dylan)
    @activity = @user.activity.build(distance: "123", strava_id: "124568")
  end

  test "should be valid" do
    assert @activity.valid?
  end

  test "user id should be present" do
    @activity.user_id = nil
    assert_not @activity.valid?
  end

  test "strava_id should be present" do
    @activity.strava_id = "   "
    assert_not @activity.valid?
  end

  test "strava_id should be unique" do
    duplicate_activity = @activity.dup
    @activity.save
    assert_not duplicate_activity.valid?
  end

  test "should delete if users destroyed" do
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @activity.reload }
  end
end
