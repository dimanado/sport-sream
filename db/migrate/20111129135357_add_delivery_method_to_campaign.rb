class AddDeliveryMethodToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :delivery_method, :string
  end
end
