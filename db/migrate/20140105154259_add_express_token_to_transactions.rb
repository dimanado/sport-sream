class AddExpressTokenToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :express_token, :string
    add_column :transactions, :express_payer_id, :string
  end
end
