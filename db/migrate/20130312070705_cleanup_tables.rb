class CleanupTables < ActiveRecord::Migration
  def up
    drop_table :accounts
    drop_table :admins
    drop_table :rails_admin_histories
    drop_table :consumer_accounts
    drop_table :categories_consumers
    drop_table :targets
  end

  def down
  end
end
