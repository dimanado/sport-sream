class AddStateToCampaignAndMessage < ActiveRecord::Migration
  def up
    add_column :campaigns, :state, :string
    add_column :messages, :state, :string
  end

  def down
    remove_column :messages, :state
    remove_column :campaigns, :state
  end
end
