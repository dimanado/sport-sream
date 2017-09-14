class AddViewedCountToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :viewed_count, :integer, :default => 0
  end
end
