class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :offer_id
      t.integer :consumer_id
      t.text :status
      t.text :transaction_id
      t.text :redemption_code

      t.timestamps
    end
  end
end
