class CreateShoppingCarts < ActiveRecord::Migration
  def up
  	create_table :shopping_carts do |t|

      t.timestamps
    end
  end

  def down
  	drop_table :shopping_carts
  end
end
