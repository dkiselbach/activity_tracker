class AddLapsToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :laps, :jsonb
    add_column :activities, :splits, :jsonb
  end
end
