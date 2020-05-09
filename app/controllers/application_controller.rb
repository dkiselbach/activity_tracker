class ApplicationController < ActionController::Base

  def hello
    render html: "This is an activity tracker app"
  end
end
