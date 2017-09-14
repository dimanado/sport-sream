class RemoveCampaignsWtf < ActiveRecord::Migration
  def up
    drop_table :campiagns if ActiveRecord::Base.connection.table_exists? 'campiagns'
  end

  def down
    # just forget that...
  end
end
