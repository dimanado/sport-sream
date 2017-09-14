class AddMoreTermsToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :more_terms, :text
  end
end
