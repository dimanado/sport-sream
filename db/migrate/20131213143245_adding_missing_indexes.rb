class AddingMissingIndexes < ActiveRecord::Migration
  def change
    add_index :businesses_categories, :business_id
    add_index :businesses_categories, :category_id
    add_index :coupon_codes, :consumer_id
    add_index :coupon_codes, :coupon_id
    add_index :coupon_codes, :transaction_id
    add_index :locations, :consumer_id
    add_index :orders, :offer_id
    add_index :orders, :consumer_id
    add_index :subscriptions, :business_id
    add_index :subscriptions, :consumer_id
  end
end
