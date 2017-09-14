class RemoveDeviseConfirmableFromConsumers < ActiveRecord::Migration
  def up
    remove_index :consumers, :confirmation_token
    remove_column :consumers, :confirmation_token
    remove_column :consumers, :confirmation_sent_at
    remove_column :consumers, :confirmed_at
  end

  def down
    add_column :consumers, :confirmation_token, :string
    add_column :consumers, :confirmation_sent_at, :datetime
    add_column :consumers, :confirmed_at, :datetime
    add_index :consumers, :confirmation_token,   :unique => true
  end
end
