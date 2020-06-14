require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @user = users(:dylan)
    @profile = @user.profile.build(weight: "150", height: "150")
  end

  test "should be valid" do
    assert @profile.valid?
  end

  test "user id should be present" do
    @profile.user_id = nil
    assert_not @profile.valid?
  end

  test "weight must be present" do
    @profile.weight = "   "
    assert_not @profile.valid?
  end

  test "weight must be valid" do
    @profile.weight = 1000
    assert_not @profile.valid?
  end

  test "should delete if users destroyed" do
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @profile.reload }
  end
end
