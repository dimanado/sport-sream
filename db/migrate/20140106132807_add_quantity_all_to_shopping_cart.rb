class AddQuantityAllToShoppingCart < ActiveRecord::Migration
  def change
    add_column :shopping_carts, :quantity_all, :integer
  end
end
