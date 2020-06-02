class AddStartDateLocalToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :start_date_local, :datetime, limit: 6
  end
end
