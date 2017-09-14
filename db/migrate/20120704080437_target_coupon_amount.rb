class TargetCouponAmount < ActiveRecord::Migration
  def up
    remove_column :targets, :limit
    add_column :coupons, :amount, :integer, :default => -1
  end

  def down
    remove_column :coupons, :amount
    add_column :targets, :limit, :integer, :default => -1
  end
end
