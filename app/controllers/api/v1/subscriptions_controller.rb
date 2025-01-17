# frozen_string_literal: true

class Api::V1::SubscriptionsController < ApplicationController
  include CheckAuth
  skip_before_action :verify_authenticity_token
  before_action :check_subscription_secret, only: [:index]

  def index
    render status: 200,
           json: { 'hub.challenge' => params['hub.challenge'] }
  end

  def create
    if params['object_type'] == 'athlete'
      # currently not handling athlete updates
      render status: 200,
             json: { success: ['athlete subscription recieved'] }
      puts params
      return
    end

    if (@user = User.find_by(strava_id: params['owner_id']))
      if @user.auth
        if params['aspect_type'] == 'create'
          ActivityCreateJob.perform_later(params['object_id'], @user.id,
                                          ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'])
        elsif params['aspect_type'] == 'update'
          ActivityUpdateJob.perform_later(params['object_id'], @user.id,
                                          ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'])
        elsif params['aspect_type'] == 'delete'
          ActivityDeleteJob.perform_later(params['object_id'])
        end
      end
    end
    render status: 200,
           json: { success: ['activity subscription recieved'] }
  end

  private

  def check_subscription_secret
    return if params['hub.verify_token'] == ENV['WEBHOOK_SECRET_KEY']

    render status: :unprocessable_entity,
           json: { error: { token: ['verify_token is invalid'] } }
  end
end
