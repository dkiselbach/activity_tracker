module ApiExceptions
  class RateLimitError < StandardError
    def initialize(msg="Api rate limit exceeded")
      super
    end
  end
end
