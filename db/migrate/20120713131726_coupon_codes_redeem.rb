class CouponCodesRedeem < ActiveRecord::Migration
  def up
    add_column :coupon_codes, :redeemed, :boolean, :default => false, :null => false
  end

  def down
    remove_column :coupon_codes, :redeemed
  end
end
