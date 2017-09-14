class RemoveMrechantsWtf < ActiveRecord::Migration
  def up
    drop_table :mrechants if ActiveRecord::Base.connection.table_exists? 'mrechants'
  end

  def down
    # forget
  end
end
