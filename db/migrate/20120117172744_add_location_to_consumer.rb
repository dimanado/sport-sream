class AddLocationToConsumer < ActiveRecord::Migration
  def change
    remove_column :consumers, :zip_code
    add_column :consumers, :location, :string
  end
end
