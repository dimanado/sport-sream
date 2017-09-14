class CouponCodesCodeString < ActiveRecord::Migration
  def up
    change_column :coupon_codes, :code, :string, :unique => true, :null => false
  end

  def down
    change_column :coupon_codes, :code, :integer, :unique => true, :null => false
  end
end
