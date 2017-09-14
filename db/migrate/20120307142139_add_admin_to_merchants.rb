class AddAdminToMerchants < ActiveRecord::Migration
  def self.up
    add_column :merchants, :is_admin, :boolean, :default => false
  end

  def self.down
    remove_column :merchants, :is_admin
  end
end
