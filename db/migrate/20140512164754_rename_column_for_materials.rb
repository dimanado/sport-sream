class RenameColumnForMaterials < ActiveRecord::Migration
  def up
    rename_column :materials, :type, :type_of_file
  end
  def down
    rename_column :materials, :type_of_file, :type
  end
end
