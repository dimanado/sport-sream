class AddCampaignTargets < ActiveRecord::Migration
  def up
    remove_column :campaigns, :target_subscribers
    create_table :targets do |t|
      t.belongs_to :campaign
      t.boolean :subscribers
      t.boolean :females
      t.boolean :males
      t.boolean :ages_13to20
      t.boolean :ages_21to34
      t.boolean :ages_35to44
      t.boolean :ages_45plus
      t.decimal :lat
      t.decimal :lng
      t.decimal :radius
    end
    add_index :targets, :campaign_id
  end

  def down
    remove_index :targets, :column => :campaign_id
    drop_table :targets
    add_column :campaigns, :target_subscribers
  end
end
