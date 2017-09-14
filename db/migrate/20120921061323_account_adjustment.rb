class AccountAdjustment < ActiveRecord::Migration
  def up
    add_column :accounts, :adjustment_applied_at, :datetime
  end

  def down
    remove_column :account, :adjustment_applied_at
  end
end
