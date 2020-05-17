require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout when not logged in" do
      get root_path
      assert_template 'static_pages/home'
      assert_select "a[href=?]", root_path, count: 2
      assert_select "a[href=?]", help_path
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path
      get contact_path
      assert_select "title", "Contact | Activity Tracker App"
      user = users(:dylan)
      sign_in user
      get root_path
      assert_select "a[href=?]", sync_activities_path
      assert_select "a[href=?]", setup_path
      assert_select "a[href=?]", edit_user_registration_path
      assert_select "a[href=?]", destroy_user_session_path
  end
end
