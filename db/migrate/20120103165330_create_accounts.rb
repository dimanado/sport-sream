class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.belongs_to :merchant
      t.integer :customer_reference
      t.integer :subscription_id
    end
  end
end
