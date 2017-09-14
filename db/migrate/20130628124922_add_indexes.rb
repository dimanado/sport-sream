class AddIndexes < ActiveRecord::Migration
  def up
    add_index :campaigns, :deliver_at
    add_index :campaigns, :expires_at
  end

  def down
  end
end
