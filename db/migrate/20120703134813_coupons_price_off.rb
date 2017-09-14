class CouponsPriceOff < ActiveRecord::Migration
  def up
    add_column :coupons, :value, :integer, :default => 0
    add_column :coupons, :percents_off, :integer, :default => 0
  end

  def down
    remove_column :coupons, :value
    remove_column :coupons, :percents_off
  end
end
