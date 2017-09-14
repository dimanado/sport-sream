class AddWebsiteToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :website, :string
  end
end
