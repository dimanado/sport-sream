class AddThumbToStockphoto < ActiveRecord::Migration
  def change
    add_column :stockphotos, :thumb, :string
  end
end
