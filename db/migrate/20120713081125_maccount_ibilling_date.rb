class MaccountIbillingDate < ActiveRecord::Migration
  def up
    add_column :merchants, :ibilling_date, :date
  end

  def down
    remove_column :merchants, :ibilling_date
  end
end
