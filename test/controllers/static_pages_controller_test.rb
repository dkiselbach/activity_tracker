require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Activity Tracker App"
  end

  test "should get root" do
    get root_url
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get home" do
    get home_path
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get home when logged in" do
    sign_in users(:dylan)
    get home_path
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get help" do
    get  help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

  test "should get setup" do
    sign_in users(:dylan)
    get setup_path
    assert_response :success
    assert_select "title", "Setup | #{@base_title}"
  end

  test "should redirect setup when not logged in" do
    get setup_path
    assert_redirected_to new_user_session_url
  end

  test "should get sync_activities" do
    sign_in users(:dylan)
    get sync_activities_path
    assert_response :success
    assert_select "title", "Sync Activities | #{@base_title}"
  end

  test "should redirect sync_activities when not logged in" do
    get sync_activities_path
    assert_redirected_to new_user_session_url
  end
end
