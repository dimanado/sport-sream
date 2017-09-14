class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.belongs_to :merchant
      t.string :name
      t.string :location
      t.text :contact_info
      t.timestamps
    end
    add_index :businesses, :merchant_id
  end
end
