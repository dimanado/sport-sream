class CouponPercentsPrice < ActiveRecord::Migration
  def up
    rename_column :coupons, :percents_off, :price
  end

  def down
    rename_column :coupons, :price, :percents_off
  end
end
