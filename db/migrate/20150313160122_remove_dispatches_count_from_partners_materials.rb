class RemoveDispatchesCountFromPartnersMaterials < ActiveRecord::Migration
  def up
    remove_column :partners, :dispatches_count
    remove_column :materials, :dispatches_count 
  end

  def down
    add_column :partners, :dispatches_count, :string
    add_column :materials, :dispatches_count, :string 
  end
end
