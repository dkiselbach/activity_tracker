class ChangeDataTypeForTime < ActiveRecord::Migration[6.0]
    def change
      change_column :activites, :time, 'integer USING CAST(time AS integer)'
    end
  end
