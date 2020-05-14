class AddUniqueIndexToActivities < ActiveRecord::Migration[6.0]
  def change
    remove_index :activities, :strava_id
    add_index :activities, :strava_id, unique: true
  end
end
