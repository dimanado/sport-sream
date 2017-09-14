class AddPublicToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :public, :boolean, default: false
  end
end
