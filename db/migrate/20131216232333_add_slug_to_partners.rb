class AddSlugToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :slug, :string
    add_index :partners, :slug, unique: true
  end
end
