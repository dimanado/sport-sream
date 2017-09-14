class LocationBelongsToConsumer < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.integer :consumer_id
    end
  end
end
