class CreateDispatchRecipients < ActiveRecord::Migration
  def change
    create_table :dispatch_recipients do |t|
      t.string :email
      t.string :status
      t.references :dispatch

      t.timestamps
    end
    add_index :dispatch_recipients, :dispatch_id
  end
end
