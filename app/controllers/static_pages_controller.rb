class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:sync_activities]

  def home
  end

  def help
  end

  def setup
  end

  def sync_activities
  end

  def about
  end

  def contact
  end
end
