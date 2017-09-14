class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :subject
      t.text :body
      t.string :status, :null => false, :default => "sent"
      t.references :sender
      t.references :recipient
      t.integer :recipient_type, :default => 0 #we may send notifications to customers/merchants
      t.boolean :send_via_email, :default => false

      t.timestamps
    end
    add_index :notifications, :sender_id
    add_index :notifications, :recipient_id
  end
end
