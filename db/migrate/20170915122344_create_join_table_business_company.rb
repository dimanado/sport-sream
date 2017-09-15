class CreateJoinTableBusinessCompany < ActiveRecord::Migration
  def change
    create_table :businesses_companies, :id => false do |t|
      t.integer :business_id
      t.integer :company_id
    end
  end
end
