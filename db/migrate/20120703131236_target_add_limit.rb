class TargetAddLimit < ActiveRecord::Migration
  def up
    add_column :targets, :limit, :integer, :default => -1
  end

  def down
    remove_columnt :targets, :limit
  end
end
