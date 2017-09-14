class AddFieldsToBusiness < ActiveRecord::Migration
  def up
    add_column :businesses, :zip_code, :string
    add_column :businesses, :city, :string
    add_column :businesses, :state, :string
    add_column :businesses, :address, :text
    add_column :businesses, :phone, :string
  end

  def down
    remove_column :businesses, :location
    remove_column :businesses, :phone
    remove_column :businesses, :address
    remove_column :businesses, :state
    remove_column :businesses, :city
    remove_column :businesses, :zip_code
  end
end
