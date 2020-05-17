class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:setup, :sync_activities]

  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def setup
  end

  def sync_activities
  end
end
