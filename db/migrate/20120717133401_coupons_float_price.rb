class CouponsFloatPrice < ActiveRecord::Migration
  def change
    change_column :coupons, :price, :decimal, :default => 0, :null => false
    change_column :coupons, :value, :decimal, :default => 0, :null => false
  end
end
