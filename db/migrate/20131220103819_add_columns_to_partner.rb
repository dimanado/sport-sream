class AddColumnsToPartner < ActiveRecord::Migration
  def change
  	add_column :partners, :url, :string
  	add_column :partners, :contact_info, :string
  	add_column :partners, :revenue_share, :integer, :default => 50
  end
end
