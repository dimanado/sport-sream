class TargetSubscription < ActiveRecord::Migration
  def up
    change_column :targets, :subscribers, :string, :limit => 16
  end

  def down
    change_column :targets, :subscribers, :boolean
  end
end
