module ApiExceptions
  class InvalidRequestError < StandardError
    def initialize(msg="The request was invalid")
      super
    end
  end
end
