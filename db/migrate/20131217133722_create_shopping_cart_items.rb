class CreateShoppingCartItems < ActiveRecord::Migration
  def up
  	create_table :shopping_cart_items do |t|
      t.shopping_cart_item_fields
      t.timestamps
    end
  end

  def down
  	drop_table :shopping_cart_items
  end
end
