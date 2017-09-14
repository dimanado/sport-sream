class CouponCodesCorrectTypo < ActiveRecord::Migration
  def up
    rename_column :coupon_codes, :purcase_date, :purchase_date
  end

  def down
    rename_column :coupon_codes, :purchase_date, :purcase_date
  end
end
