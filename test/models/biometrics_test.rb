require 'test_helper'

class BiometricsTest < ActiveSupport::TestCase
  def setup
    @user = users(:dylan)
    @biometrics = @user.biometric.build(weight: "150")
  end

  test "should be valid" do
    assert @biometrics.valid?
  end

  test "user id should be present" do
    @biometrics.user_id = nil
    assert_not @biometrics.valid?
  end

  test "weight must be present" do
    @biometrics.weight = "   "
    assert_not @biometrics.valid?
  end

  test "weight must be valid" do
    @biometrics.weight = 1000
    assert_not @biometrics.valid?
  end

  test "should delete if users destroyed" do
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @biometrics.reload }
  end
end
