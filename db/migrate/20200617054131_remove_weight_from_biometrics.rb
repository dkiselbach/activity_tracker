class RemoveWeightFromBiometrics < ActiveRecord::Migration[6.0]
  def change
    remove_column :biometrics, :height, :integer
  end
end
