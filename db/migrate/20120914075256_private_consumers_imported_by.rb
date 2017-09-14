class PrivateConsumersImportedBy < ActiveRecord::Migration
  def up
    add_column :consumers, :imported_by, :integer, :null => false, :default => 0
  end

  def down
    remove_column :consumers, :imported_by
  end
end
