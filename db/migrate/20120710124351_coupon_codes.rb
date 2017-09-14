class CouponCodes < ActiveRecord::Migration
  def up
    create_table :coupon_codes do |t|
      t.belongs_to :consumer
      t.belongs_to :coupon
      t.integer :transaction_id, :unique => true, :null => :false
      t.integer :code, :unique => true, :null => false
    end
  end

  def down
    drop_table :coupon_codes
  end
end
