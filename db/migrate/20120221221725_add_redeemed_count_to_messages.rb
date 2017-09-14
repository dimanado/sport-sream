class AddRedeemedCountToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :redeemed_count, :integer, :default => 0
  end
end
