class MoveCouponLogoToBusinesses < ActiveRecord::Migration
  def up
    add_column :businesses, :coupon_logo_file_name, :string
    add_column :businesses, :coupon_logo_content_type, :string
    add_column :businesses, :counpon_logo_file_size, :integer
    remove_column :coupons, :logo_file_name
    remove_column :coupons, :logo_content_type
    remove_column :coupons, :logo_file_size
  end

  def down
    remove_column :businesses, :coupon_logo_file_name
    remove_column :businesses, :coupon_logo_content_type
    remove_column :businesses, :counpon_logo_file_size
    add_column :coupons, :logo_file_name, :string
    add_column :coupons, :logo_content_type, :string
    add_column :coupons, :logo_file_size, :integer
  end
end
