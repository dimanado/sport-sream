class CreateMaterialTable < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :file,           :null => false
      t.string :title
      t.string :type,           :null => false
      t.integer :dispatches_count
    end
    add_index :materials, [:type], name: 'index_materials_by_type'
  end
end
