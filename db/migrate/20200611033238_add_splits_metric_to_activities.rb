class AddSplitsMetricToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :splits_metric, :jsonb
  end
end
