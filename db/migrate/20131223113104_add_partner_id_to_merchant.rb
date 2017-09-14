class AddPartnerIdToMerchant < ActiveRecord::Migration
  def change
  	add_column :merchants, :partner_id, :integer
  	add_index :merchants, :partner_id
  end
end
