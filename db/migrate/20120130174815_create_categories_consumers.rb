class CreateCategoriesConsumers < ActiveRecord::Migration
  def change
    create_table :categories_consumers, :id => false do |t|
      t.integer :consumer_id
      t.integer :category_id
    end
  end
end
