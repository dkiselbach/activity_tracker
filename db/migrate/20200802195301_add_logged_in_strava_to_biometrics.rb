# frozen_string_literal: true

class AddLoggedInStravaToBiometrics < ActiveRecord::Migration[6.0]
  def change
    add_column :biometrics, :strava_updated, :boolean, default: false
  end
end
