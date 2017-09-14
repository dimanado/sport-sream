class AddCampaignTargetOption < ActiveRecord::Migration
  def up
    add_column :campaigns, :target_subscribers, :boolean
  end

  def down
    remove_column :campaigns, :target_subscribers
  end
end
