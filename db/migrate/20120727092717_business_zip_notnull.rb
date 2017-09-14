class BusinessZipNotnull < ActiveRecord::Migration
  def up
    change_column :businesses, :zip_code, :string, :null => false
  end

  def down
    change_column :businesses, :zip_code, :string, :null => true
  end
end
