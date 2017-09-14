class AddGeocodeToBusinesses < ActiveRecord::Migration
  def up
    add_column :businesses, :latitude, :float
    add_column :businesses, :longitude, :float
  end

  def down
    remove_column :businesses, :longitude
    remove_column :businesses, :latitude
  end
end
