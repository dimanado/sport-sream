class ConsumersWeeklyDigest < ActiveRecord::Migration
  def up
    change_table :consumers do |t|
      t.boolean :weekly_digest, :default => false
    end
    Consumer.update_all ["weekly_digest = ?", true]
  end

  def down
    remove_column :consumers, :weekly_digest
  end
end
