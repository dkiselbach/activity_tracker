class Api::V1::SubscriptionsController < ApplicationController
  include CheckAuth
  skip_before_action :verify_authenticity_token
  before_action :check_subscription_secret, only: [:index]

  def index
    render :status => 200,
           :json => { "hub.challenge" => params["hub.challenge"]}
  end

  def create
    @user = User.find_by(strava_id: params["owner_id"])
    if params["aspect_type"] == "create"
      ActivityCreateJob.perform_later(params["object_id"], @user)
    elsif params["aspect_type"] == "update"
      ActivityUpdateJob.perform_later(params["object_id"], @user)
    elsif params["aspect_type"] == "delete"
      ActivityDeleteJob.perform_later(params["object_id"])
    end
    render :status => 200,
           :json => { :success => ["subscription recieved"]}
  end

  private

    def check_subscription_secret
      return if params["hub.verify_token"] == ENV["WEBHOOK_SECRET_KEY"]
      render :status => :unprocessable_entity,
             :json => { :error => { :token => ["verify_token is invalid" ]} }
    end
end
