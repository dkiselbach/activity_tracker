require 'test_helper'

class ThrottleTest < ActiveSupport::TestCase
  def setup
    @user = users(:dylan)
    @throttle = @user.throttle.create(hourly_usage: 100, daily_usage: 100, app_name: "Strava")
    @throttle_daily = @user.throttle.create(hourly_usage: 100, daily_usage: 1000, app_name: "Strava")
  end

  test "should be valid" do
    assert @throttle.valid?
  end

  test "user id must be present" do
    @throttle.user_id = nil
    assert_not @throttle.valid?
  end

  test "test set hourly limit" do
    assert_equal "15-minute", @throttle.limit_type
  end

  test "test set daily limit" do
    assert_equal "daily", @throttle_daily.limit_type
  end

  test "test limited?" do
    assert @throttle.limited? && @throttle_daily.limited?
    @throttle.created_at = Time.now - 15.minutes
    assert !@throttle.limited?
    @throttle_daily.created_at = Time.now - 1.day
    assert !@throttle_daily.limited?
  end

  test "should delete if users destroyed" do
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @throttle.reload }
  end
end
