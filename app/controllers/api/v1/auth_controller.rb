# frozen_string_literal: true

class Api::V1::AuthController < ApplicationController
  include HttpRequest
  include CheckAuth
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def create
    scope = 'read,activity:read_all,read_all'

    if params[:code].present? && params[:scope] == scope

      url = "#{ENV['STRAVA_SITE_BASE']}/oauth/token"
      body = {
        'grant_type' => 'authorization_code',
        'code' => params[:code].to_s,
        'client_id' => (ENV['STRAVA_CLIENT_ID']).to_s,
        'client_secret' => (ENV['STRAVA_CLIENT_SECRET']).to_s
      }

      results = post(url, body)

      if results
        auth = current_user.build_auth(app_name: 'Strava', token: (results['access_token']).to_s,
                                       refresh_token: (results['refresh_token']).to_s)

        if auth.save
          profile_image = open(results['athlete']['profile'])
          current_user.update(strava_id: (results['athlete']['id']).to_s, strava_username: (results['athlete']['username']).to_s)
          current_user.image.purge_later
          current_user.image.attach(io: profile_image, filename: "#{current_user.strava_username}.jpeg", content_type: 'image/jpg')

          render status: 200,
                 json: { success: ['Strava successfully connected'] }
        else
          render status: :unprocessable_entity,
                 json: { error: { auth: ['error saving auth'] } }
        end
      else
        render status: :unprocessable_entity,
               json: { error: { auth_code: ['is invalid'] } }
      end
    elsif params[:code].present?
      render status: :unprocessable_entity,
             json: { error: { scope: ['is blank or invalid'] } }
    elsif params[:scope] == scope
      render status: :unprocessable_entity,
             json: { error: { auth_code: ['is blank'] } }
    else
      render status: :unprocessable_entity,
             json: { error: { auth_code: ['is blank'],
                              scope: ['is blank or invalid'] } }
    end
  end

  def destroy
    post("#{ENV['STRAVA_SITE_BASE']}/oauth/deauthorize", {}, current_user.auth.token) if current_user.auth

    if @success
      current_user.auth.destroy
      render status: 200,
             json: { success: ['Strava auth successfully deauthorized'] }
    end
  rescue ApiExceptions::AuthenticationError
    # using the refreshed token, destroy should work if retried
    retry if refresh(current_user, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'])

    # User's auth is invalid so remove it
    current_user.auth.destroy

    render status: 200,
           json: { success: ['Strava auth successfully deauthorized'] }
  end

  def index
    check_auth(current_user, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'])
    if @success
      render status: 200,
             json: { success: [@success] }
    else
      render status: :unprocessable_entity,
             json: { error: @error }
    end
  rescue ApiExceptions::AuthenticationError
    if refresh(current_user, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'])
      render status: 200, json: { success: ['Strava auth is valid'] }
      return
    end

    # User's auth is invalid so remove it
    current_user.auth.destroy

    render status: 401, json: { error: { strava_auth: ['Strava auth is invalid and has been removed'] } }
  end
end
