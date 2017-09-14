class AddRedemptionUrlToMessages < ActiveRecord::Migration
  def up
    add_column :messages, :redemption_code, :string
  end

  def down
    remove_column :messages, :redemption_code
  end
end
