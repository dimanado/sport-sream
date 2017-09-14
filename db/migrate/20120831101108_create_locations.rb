class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, :null => false
      t.string :zip_code, :limit => 5, :null => false
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
