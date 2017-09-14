class ChangeAmountDecimalFormatInTransactions < ActiveRecord::Migration
  def up
    change_column :transactions, :amount, :decimal, { :scale => 2, :precision => 10 }
  end

  def down
    change_column :transactions, :amount, :decimal
  end
end
