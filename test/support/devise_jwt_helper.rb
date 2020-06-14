module DeviseJwtHelper
  def sign_in(user)
  # The argument 'user' should be a hash that includes the params 'email' and 'password'.
    post '/users/sign_in',
    params: { email: user.email, password: "password" },
    as: :json
    @authorization = response.headers.slice('Authorization')
  end

  def invalid_sign_in(user)
    # The argument 'user' should be a hash that includes the params 'email' and 'password'.
    post '/users/sign_in',
      params: { email: user.email, password: "foobar" },
      as: :json
    response.headers.slice('Authorization')
  end

  def jwt_login(user)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @authorization = Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end
