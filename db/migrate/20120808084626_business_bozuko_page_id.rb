class BusinessBozukoPageId < ActiveRecord::Migration
  def up
    add_column :businesses, :bozuko_page_id, :string
  end

  def down
    remove_column :businesses, :bozuko_page_id
  end
end
