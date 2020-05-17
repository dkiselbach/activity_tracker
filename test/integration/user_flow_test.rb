require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  test "successful login" do
    user = users(:dylan)
    post user_session_path, params: {user: {
      email:    user.email,
      password: 'password'
    }}
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_equal "Signed in successfully.", flash[:notice]
    assert_select "a[href=?]", setup_path
    assert_select "a[href=?]", edit_user_registration_path
    assert_select "a[href=?]", destroy_user_session_path
    get root_path
    assert flash.empty?
  end

  test "unsuccessful login" do
    user = users(:dylan)
    post user_session_path, params: {user: {
      email:    user.email,
      password: 'password1'
    }}
    assert_template 'devise/sessions/new'
    assert_equal "Invalid Email or password.", flash[:alert]
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", new_user_session_path
    get root_path
    assert flash.empty?
  end

  test "successful login with unconfirmed user" do
    user = users(:archer)
    post user_session_path, params: {user: {
      email:    user.email,
      password: 'password'
    }}
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template 'devise/sessions/new'
    assert_equal "You have to confirm your email address before continuing.", flash[:alert]
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", new_user_session_path
    get root_path
    assert flash.empty?
  end

  test "successful signup with name" do
    get new_user_registration_path
    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: { name: 'Example User',
                                                     email: 'user@example.com',
                                                     password: 'password',
                                                     password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.confirmed?
    # Try to log in before confirmation.
    post user_session_path, params: {user: {
      email:    user.email,
      password: 'password'
    }}
    assert_redirected_to new_user_session_path
    # Invalid confirmation token
    get user_confirmation_path(confirmation_token: "invalid_token")
    assert_template 'devise/confirmations/new'
    assert_select 'div#error_explanation'
    # Valid confirmation token
    get user_confirmation_path(confirmation_token: user.confirmation_token)
    assert user.reload.confirmed?
    follow_redirect!
    assert_template 'devise/sessions/new'
  end

  test "successful edit with name" do
    user = users(:dylan)
    sign_in user
    get edit_user_registration_path
    name = "Test User"
    patch user_registration_path, params: {user: {
      name: name,
      email:    user.email,
      current_password: 'password'
    }}
    assert_redirected_to root_url
    follow_redirect!
    assert_equal "Your account has been updated successfully.", flash[:notice]
    user.reload
    assert_equal user.name, name
    get root_url
    assert flash.empty?
  end
end
