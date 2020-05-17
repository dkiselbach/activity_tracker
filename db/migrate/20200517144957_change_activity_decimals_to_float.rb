class ChangeActivityDecimalsToFloat < ActiveRecord::Migration[6.0]
  def change
      change_column :activities, :distance, :integer
      change_column :activities, :avg_hr, :integer
      change_column :activities, :calories, :integer
  end
end
