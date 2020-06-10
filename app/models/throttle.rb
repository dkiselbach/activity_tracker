class Throttle < ApplicationRecord
  belongs_to :user
  validates :hourlyusage, :dailyusage, :appname, :user_id, presence: true
  before_save :set_limit

  def set_limit
    if dailyusage > 1000
      self.limit_type = "daily"
    else
      self.limit_type = "15-minute"
    end
  end
end
