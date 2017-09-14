class RemoveFieldsFromCoupon < ActiveRecord::Migration
  def up
    remove_column :coupons, :thumb
    remove_column :coupons, :promo_image_file_name
    remove_column :coupons, :promo_image_content_type
    remove_column :coupons, :promo_image_file_size
    remove_column :coupons, :background_color
    remove_column :coupons, :font_color
    remove_column :coupons, :text_logo
    remove_column :coupons, :value
    remove_column :coupons, :price
    remove_column :coupons, :color_scheme
  end

end
