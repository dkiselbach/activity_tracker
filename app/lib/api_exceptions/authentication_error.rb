module ApiExceptions
  class AuthenticationError < StandardError
    def initialize(msg="Access token expired or invalid")
      super
    end
  end
end
