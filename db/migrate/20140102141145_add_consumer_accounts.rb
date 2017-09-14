class AddConsumerAccounts < ActiveRecord::Migration
  def change
    drop_table :consumer_accounts if ActiveRecord::Base.connection.table_exists? 'consumer_accounts'
    create_table :consumer_accounts
  end
end
