class AddBraintreeToUsers < ActiveRecord::Migration
  def change
    add_column :consumers, :braintree_customer_id, :text
  end
end
