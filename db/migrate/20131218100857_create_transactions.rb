class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :braintree_transaction_id
      t.references :consumer
      t.references :shopping_cart
      t.decimal :amount
      t.string :status

      t.timestamps
    end
  end
end
