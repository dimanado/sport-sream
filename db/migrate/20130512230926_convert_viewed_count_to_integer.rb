class ConvertViewedCountToInteger < ActiveRecord::Migration
  def up
    change_column :coupons, :viewed_count, :integer
  end

  def down
    change_column :coupons, :viewed_count, :integer
  end
end
