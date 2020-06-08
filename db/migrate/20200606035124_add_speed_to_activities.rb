class AddSpeedToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :speed, :float
  end
end
