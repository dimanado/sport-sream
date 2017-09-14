class AddViewedCountToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :viewed_count, :string
  end
end
