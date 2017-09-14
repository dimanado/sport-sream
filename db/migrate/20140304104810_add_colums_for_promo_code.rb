class AddColumsForPromoCode < ActiveRecord::Migration
  def change
    add_column :businesses, :online_business, :string
    add_column :coupons, :promo_code, :string
  end
end
