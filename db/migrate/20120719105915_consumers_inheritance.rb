class ConsumersInheritance < ActiveRecord::Migration
  def up
    add_column :consumers, :type, :string
  end

  def down
    remove_column :consumers, :type
  end
end
