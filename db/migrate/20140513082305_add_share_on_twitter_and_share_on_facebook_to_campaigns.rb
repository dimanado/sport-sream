class AddShareOnTwitterAndShareOnFacebookToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :facebook_share, :string, null: true
    add_column :campaigns, :twitter_share, :string, null: true
  end
end
