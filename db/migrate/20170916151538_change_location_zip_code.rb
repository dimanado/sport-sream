class ChangeLocationZipCode < ActiveRecord::Migration
  def up
    change_column :locations, :zip_code, :string, :limit => 6
  end

  def down
    change_column :locations, :zip_code, :string, :limit => 5
  end
end
