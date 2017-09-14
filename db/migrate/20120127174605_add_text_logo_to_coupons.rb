class AddTextLogoToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :text_logo, :string
  end
end
