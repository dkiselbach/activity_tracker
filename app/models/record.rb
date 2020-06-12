class Record < ApplicationRecord
  belongs_to :user
  belongs_to :activity, :foreign_key => 'strava_id', :class_name => 'Activity',
    :primary_key => 'strava_id'
  validates :strava_id, :name, :distance, :elapsed_time, :moving_time, :pr_rank, presence: true
  validates_uniqueness_of :strava_id, scope: %i[name]
end
