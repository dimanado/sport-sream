class AddDeletedAtToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :deleted_at, :datetime
  end
end
