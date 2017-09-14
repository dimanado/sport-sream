class CreateConsumers < ActiveRecord::Migration
  def change
    create_table :consumers do |t|
      t.string :name
      t.string :email
      t.string :mobile
      t.string :carrier

      t.timestamps
    end
  end
end
