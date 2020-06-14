require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:dylan)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
end
