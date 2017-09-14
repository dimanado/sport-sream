class AddCompaniesAndLocationsAndStream < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :title
      t.string :description
    end

    # create_table :locations do |t|
    #   t.string :city
    #   t.string :address
    #   t.string :phone
    #   t.references :company
    # end
    add_column :locations, :company_id, :integer

    create_table :streams do |t|
      t.string :title
      t.string :link
      t.references :location
    end
  end
end
