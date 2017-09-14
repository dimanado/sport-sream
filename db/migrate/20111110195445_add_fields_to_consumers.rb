class AddFieldsToConsumers < ActiveRecord::Migration
  def change
    change_table "consumers" do |t|
      t.integer :birth_year
      t.string :gender, :limit => 1
      t.decimal :lat, :precision => 16, :scale => 8
      t.decimal :lng, :precision => 16, :scale => 8
      t.string :zip_code
      t.boolean :optin
      t.boolean :enabled
    end
  end
end
