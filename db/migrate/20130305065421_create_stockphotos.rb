class CreateStockphotos < ActiveRecord::Migration
  def change
    create_table :stockphotos do |t|
      t.string :img
      t.string :category

      t.timestamps
    end
  end
end
