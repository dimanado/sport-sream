class CreateJoinTableCompanyMerchant < ActiveRecord::Migration
  def change
    create_table :companies_merchants, :id => false do |t|
      t.integer :merchant_id
      t.integer :company_id
    end
  end
end

