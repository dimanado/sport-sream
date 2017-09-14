class AddRoleToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :role, :string, default: 'partner'
  end
end
