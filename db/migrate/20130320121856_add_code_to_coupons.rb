class AddCodeToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :code, :string
    add_column :coupons, :sold_count, :integer
  end
end
