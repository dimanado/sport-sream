class ChangeDispatchesTable < ActiveRecord::Migration
  def change
    drop_table :dispatches 

    create_table :dispatches do |t|
      t.references :partner

      t.timestamps
    end
    add_index :dispatches, :partner_id 

    create_table :dispatches_materials, id: false do |t|
      t.belongs_to :dispatch, index: true
      t.belongs_to :material, index: true
    end
  end
end
