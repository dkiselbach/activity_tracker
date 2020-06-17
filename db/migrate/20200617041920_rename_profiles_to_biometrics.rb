class RenameProfilesToBiometrics < ActiveRecord::Migration[6.0]
  def change
    rename_table :profiles, :biometrics
  end
end
