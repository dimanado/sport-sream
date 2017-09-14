class CouponCodeAddDate < ActiveRecord::Migration
  def up
    add_column :coupon_codes, :purcase_date, :datetime
  end

  def down
    remove_column :coupon_codes, :purcase_date, :datetime
  end
end
