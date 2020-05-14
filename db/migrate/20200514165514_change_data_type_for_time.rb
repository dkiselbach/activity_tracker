class ChangeDataTypeForTime < ActiveRecord::Migration[6.0]
  def down
    remove_columns :activities, :time, :datetime
  end
  def up
    add_column :activities, :activity_time, :integer
  end
end
