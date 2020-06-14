require 'test_helper'

class Api::V1::DeviseControllerTest < ActionDispatch::IntegrationTest
  test "successful login" do
    user = users(:dylan)
    sign_in(user)
    assert_response 200
  end

  test "unsuccessful login" do
    user = users(:dylan)
    invalid_sign_in(user)
    json_response = JSON.parse(response.body)
    assert_equal ["doesn't match Password"], json_response["error"]["password"]
  end

  test "login with unconfirmed user" do
    user = users(:archer)
    sign_in(user)
    json_response = JSON.parse(response.body)
    assert_response 401
    assert_equal ["Email not confirmed"], json_response["error"]["email"]
  end

  test "login with wrong email" do
    post user_session_path, params: { email: 'fake@example.com',
                                      password: 'password'}
    json_response = JSON.parse(response.body)
    assert_response 401
    assert_equal ["Email doesn't exist"], json_response["error"]["email"]
  end

  test "post valid signup with confirmation should create a new user" do
    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: { name: 'Example User',
                                                     email: 'user@example.com',
                                                     password: 'password',
                                                     password_confirmation: 'password' } }
    end
    json_response = JSON.parse(response.body)
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal ["Registered"], json_response["success"]
    user = assigns(:user)
    assert_not user.confirmed?
    # Try to log in before confirmation.
    sign_in(user)
    assert_response 401
    #Invalid confirmation token
    get user_confirmation_path(confirmation_token: "invalid_token")
    json_response = JSON.parse(response.body)
    assert_equal ["is invalid"], json_response["error"]["confirmation_token"]
    #Valid confirmation token
    get user_confirmation_path(confirmation_token: user.confirmation_token)
    json_response = JSON.parse(response.body)
    assert_equal ["User confirmed"], json_response["success"]
    assert_equal ["user@example.com"], json_response["email"]
    assert user.reload.confirmed?
  end

  test "successfull password reset" do
    user = users(:dylan)
    reset_password_token  = user.send_reset_password_instructions
    assert_equal 1, ActionMailer::Base.deliveries.size
    #Invalid reset token
    put user_password_path, params: { user: { reset_password_token: "Invalid Token", password: "test123", password_confirmation: "test123"}}
    json_response = JSON.parse(response.body)
    assert_equal ["is invalid"], json_response["error"]["reset_password_token"]
    #Valid reset token
    put user_password_path, params: { user: { reset_password_token: reset_password_token, password: "test123", password_confirmation: "test123"}}
    json_response = JSON.parse(response.body)
    assert_equal ["Password reset"], json_response["success"]
  end

  test "password reset email gets sent" do
    user = users(:dylan)
    post user_password_path, params: { user: { email: user.email}}
    json_response = JSON.parse(response.body)
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal ["Email sent"], json_response["success"]
  end

  test "resend confirmation token" do
    user = users(:archer)
    post user_confirmation_path, params: { user: {
    	"email": user.email }}
    json_response = JSON.parse(response.body)
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal ["Email sent"] , json_response["success"]
    #Verify the sent token works
    get user_confirmation_path(confirmation_token: user.confirmation_token)
    json_response = JSON.parse(response.body)
    assert_equal ["User confirmed"], json_response["success"]
    assert_equal ["archer@example.org"], json_response["email"]
    assert user.reload.confirmed?
  end
end
