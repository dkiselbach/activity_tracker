module ApiExceptions
  class ThrottledError < StandardError
    def initialize(msg="Throttled until rate limit reset")
      super
    end
  end
end
