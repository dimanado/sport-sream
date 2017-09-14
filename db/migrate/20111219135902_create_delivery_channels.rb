class CreateDeliveryChannels < ActiveRecord::Migration
  def up
    create_table :delivery_channels do |t|
      t.belongs_to :campaign
      t.string :type

      t.timestamps
    end
    add_index :delivery_channels, :campaign_id
  end

  def down
    remove_index :delivery_channels, :campaign_id
    drop_table :delivery_channels
  end
end
