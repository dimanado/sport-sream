class AddMerchantName < ActiveRecord::Migration
  def up
    add_column :merchants, :name, :string
  end

  def down
    remove_column :merchants, :name
  end
end
