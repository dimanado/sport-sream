class AddCompaniesAndLocationsAndStream < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :title
      t.string :description
    end

    add_column :locations, :company_id, :integer

    create_table :streams do |t|
      t.string :title
      t.string :link
      t.references :location
    end
  end
end
