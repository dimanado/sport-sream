class ChangeLatLngColumnNamesForGeoCoder < ActiveRecord::Migration
  def up
    remove_column :consumers, :lat
    remove_column :consumers, :lng
    remove_column :targets, :lat
    remove_column :targets, :lng
    add_column :consumers, :latitude, :float
    add_column :consumers, :longitude, :float
    add_column :targets, :latitude, :float
    add_column :targets, :longitude, :float
    add_column :targets, :zip_code, :string
  end

  def down
    remove_column :targets, :zip_code
    remove_column :targets, :longitude
    remove_column :targets, :latitude
    remove_column :consumers, :longitude
    remove_column :consumers, :latitude
    add_column :targets, :lng
    add_column :targets, :lat
    add_column :consumers, :lng
    add_column :consumers, :lat
  end
end
