require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  def setup
    @user = users(:dylan)
    @record = @user.record.build(strava_id: 123458, name: "Half-Marathon", distance: 21097, start_date_local: Time.now, pr_rank: 1, elapsed_time: 60, moving_time: 55)
  end

  test "should be valid" do
    assert @record.valid?
  end

  test "user id must be present" do
    @record.user_id = nil
    assert_not @record.valid?
  end

  test "strava id must be present" do
    @record.strava_id = "   "
    assert_not @record.valid?
  end

  test "strava id and record type must be unique" do
    @record.strava_id = 123456
    assert_not @record.valid?
  end

  test "should delete if users destroyed" do
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @record.reload }
  end

  test "should delete if activity destroyed" do
    Activity.find_by(strava_id: @record.strava_id).destroy
    assert_raise(ActiveRecord::RecordNotFound) { @record.reload }
  end
end
