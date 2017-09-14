class CreateMaterialDownloads < ActiveRecord::Migration
  def change
    create_table :material_downloads do |t|
      t.references :partner
      t.references :material

      t.timestamps
    end
    add_index :material_downloads, :partner_id
    add_index :material_downloads, :material_id
  end
end
