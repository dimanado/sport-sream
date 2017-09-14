class RemoveFieldsFromBusinesses < ActiveRecord::Migration
  def up
    remove_column :businesses, :activation_code
    remove_column :businesses, :bozuko_page_id
  end

  def down
  end
end
