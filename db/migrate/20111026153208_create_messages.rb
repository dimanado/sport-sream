class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :campaign
      t.belongs_to :recipient
      t.string :type
      t.boolean :delivered
      t.datetime :opened_at
      t.datetime :redeemed_at
      t.timestamps
    end
  end
end
