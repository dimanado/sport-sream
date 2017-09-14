class CreateBusinessInvites < ActiveRecord::Migration
  def change
    create_table :business_invites do |t|
      t.text :materials
      t.string :email
      t.string :status
      t.datetime :confirmation_date
      t.references :partner

      t.timestamps
    end
    add_index :business_invites, :partner_id
  end
end
