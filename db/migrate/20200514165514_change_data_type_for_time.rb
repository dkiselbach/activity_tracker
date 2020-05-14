class ChangeDataTypeForTime < ActiveRecord::Migration[6.0]
  def up
    add_column :activities, :time, :integer
  end
  def down
    remove_columns :activities, :time, :datetime
  end
end
