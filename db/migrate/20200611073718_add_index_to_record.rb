class AddIndexToRecord < ActiveRecord::Migration[6.0]
  def change
    add_index :records, :strava_id
  end
end
