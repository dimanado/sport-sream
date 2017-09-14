class AddFieldsToShoppingCart < ActiveRecord::Migration
  def change
  	add_column :shopping_carts, :consumer_id ,:integer
  	add_index :shopping_carts, :consumer_id
  	add_column :shopping_carts, :status, :string
  	add_column :shopping_carts, :redemption_code, :string
  	add_column :shopping_carts, :partner_id, :integer
  	add_index :shopping_carts, :partner_id
  end
end
