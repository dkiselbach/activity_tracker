class CustomFailure < Devise::FailureApp

  def respond
    # We override Devise's handling to throw our own custom errors on unconfirmed email failures
    # because Devise provides no easy way to deal with them:

    if warden_message == :unconfirmed
      self.status = 401
      self.content_type = 'json'
      self.response_body = {"error" => {"email" => ["Email not confirmed"]}}.to_json
    elsif warden_options[:recall]
      recall
    else
      self.status = 401
      self.content_type = 'json'
      self.response_body = {"error" => {"authentication" => ["Authentication is invalid"]}}.to_json
    end
  end
end
