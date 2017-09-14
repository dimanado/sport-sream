class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.belongs_to :business
      t.datetime :deliver_at
      t.datetime :expires_at
      t.string :type
      t.string :message_content
      t.text :coupon_content
      t.timestamps
    end
    add_index :campaigns, :business_id
  end
end
