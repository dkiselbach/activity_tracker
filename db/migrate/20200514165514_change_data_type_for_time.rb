class ChangeDataTypeForTime < ActiveRecord::Migration[6.0]
    def self.up
    change_table :activities do |t|
      t.change :time, :integer
    end
  end
  def self.down
    change_table :activites do |t|
      t.change :time, :datetime
    end
  end
end
