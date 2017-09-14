class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to "business"
      t.belongs_to "consumer"
      t.timestamps
    end
  end
end
