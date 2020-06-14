module DeviseJwtHelper
  def sign_in(user)
  # The argument 'user' should be a hash that includes the params 'email' and 'password'.
    post user_session_path,
    params: { email: user.email, password: "password" },
    as: :json
    @authorization = response.headers.slice('Authorization')
  end

  def invalid_sign_in(user)
    # The argument 'user' should be a hash that includes the params 'email' and 'password'.
    post user_session_path,
      params: { email: user.email, password: "foobar" },
      as: :json
    response.body
  end

  def jwt_login(user)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @authorization = Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end
