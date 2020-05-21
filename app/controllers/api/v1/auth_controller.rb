class Api::V1::AuthController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:code].present? && params[:scope] == "read,activity:read"
      @auth = current_user.build_auth()
      if @auth.access(params[:code])
        render :status => 200,
               :json => { :success => ["Strava successfully connected"]}
      else
        render :status => :unprocessable_entity,
               :json => { :error => { :auth_code => ["is invalid"] } }
      end
    elsif params[:code].present?
      render :status => :unprocessable_entity,
             :json => { :error => { :scope => ["is blank or invalid"] } }
    elsif params[:scope] == "read,activity:read"
      render :status => :unprocessable_entity,
             :json => { :error => { :auth_code => ["is blank"] } }
    else
      render :status => :unprocessable_entity,
             :json => { :error => { :auth_code => ["is blank"],
                                    :scope => ["is blank or invalid"]}}
    end
  end
end
