class AddLogoFieldsToBusiness < ActiveRecord::Migration
  def change
    change_table :businesses do |t|
      t.string :logo_file_name
      t.string :logo_content_type
      t.integer :logo_file_size
    end
  end
end
