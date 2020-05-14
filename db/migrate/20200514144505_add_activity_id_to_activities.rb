class AddActivityIdToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :strava_id, :integer
    add_column :activities, :name, :string
    add_column :activities, :type, :string
    remove_index :activities, name: "index_activities_on_user_id"
    add_index :activities, :strava_id
  end
end
