class AddColorSchemesToCoupon < ActiveRecord::Migration
  def change
    change_table :coupons do |t|
      t.string :background_color
      t.string :font_color
    end
  end
end
