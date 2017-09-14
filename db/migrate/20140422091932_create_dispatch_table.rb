class CreateDispatchTable < ActiveRecord::Migration
  def change
    create_table :dispatches do |t|
      t.belongs_to :material
      t.belongs_to :partner
    end
    add_index "dispatches", ["material_id"], :name => "index_dispatch_on_material_id"
    add_index "dispatches", ["partner_id"], :name => "index_dispatch_on_partner_id"
  end
end
