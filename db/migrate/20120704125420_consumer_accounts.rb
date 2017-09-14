class ConsumerAccounts < ActiveRecord::Migration
  def up
    create_table :consumer_accounts do |t|
      t.belongs_to :consumer
      t.integer :subscription_id, :null => false
    end
  end

  def down
    drop_table :consumer_accounts
  end
end
