class AddFirstNameToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :first_name, :string
    add_column :transactions, :last_name, :string
  end
end
