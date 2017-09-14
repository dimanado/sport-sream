class RemoveDeliveryMethodFromCampaign < ActiveRecord::Migration
  def up
    remove_column :campaigns, :delivery_method
  end
  
  def down
    add_column :campaigns, :delivery_method, :string
  end
end
