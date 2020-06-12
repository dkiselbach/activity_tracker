class Throttle < ApplicationRecord
  belongs_to :user
  validates :hourly_usage, :daily_usage, :app_name, :user_id, presence: true
  before_save :set_limit

  def set_limit
    if daily_usage > 1000
      self.limit_type = "daily"
    else
      self.limit_type = "15-minute"
    end
  end

  def limited?
    if self.limit_type == "daily"
      if Time.now.utc.to_date > self.created_at.utc.to_date
        return false
      else
        @time = ((Time.now.utc.midnight.tomorrow - Time.now.utc)/60).minutes
      end
    elsif self.limit_type == "15-minute"
      if Time.now.utc > self.created_at.utc + 15 * 60
        return false
      else
        @time = (((self.created_at.utc + 15 * 60) - Time.now.utc)/60).minutes
      end
    end
  end
end
