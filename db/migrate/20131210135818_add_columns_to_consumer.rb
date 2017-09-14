class AddColumnsToConsumer < ActiveRecord::Migration
  def change
    add_column :consumers, :uid, :integer
    add_column :consumers, :provider, :string
  end
end
