require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "Activity Tracker App"
    assert_equal full_title("Help"), "Help | Activity Tracker App"
  end
end
