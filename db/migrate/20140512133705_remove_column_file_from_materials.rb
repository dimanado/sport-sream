class RemoveColumnFileFromMaterials < ActiveRecord::Migration
  def up
    remove_column :materials, :file
  end
  def down
    add_column :materials, :file
  end
end
