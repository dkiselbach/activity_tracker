class RemoveTimeFromActivities < ActiveRecord::Migration[6.0]
  def change
    remove_column :activities, :time, :datetime
  end
end
