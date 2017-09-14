class RemoveEmailFromConsumer < ActiveRecord::Migration
  def up
    remove_column :consumers, :email
  end

  def down
    add_column :consumers, :email, :string
  end
end
