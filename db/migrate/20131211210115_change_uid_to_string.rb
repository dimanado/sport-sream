class ChangeUidToString < ActiveRecord::Migration
  def up
    change_column :consumers, :uid, :string
  end

  def down
  end
end
