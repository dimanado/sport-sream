class Ziplocations < ActiveRecord::Migration
  def up
    create_table :ziplocations do |t|
      t.string :zip_code
      t.float :latitude
      t.float :longitude
    end
  end

  def down
    remove_table :ziplocations
  end
end
