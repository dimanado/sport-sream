class DropBusinessInvitesTable < ActiveRecord::Migration
  def up
  	drop_table :business_invites
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
