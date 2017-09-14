class RemoveContactInfoFromBusinesses < ActiveRecord::Migration
  def up
    remove_column :businesses, :contact_info
  end

  def down
    add_column :businesses, :contact_info, :text
  end
end
