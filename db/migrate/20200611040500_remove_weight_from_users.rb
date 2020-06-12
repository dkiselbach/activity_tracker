class RemoveWeightFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :weight, :integer
    remove_column :users, :height, :integer
  end
end
