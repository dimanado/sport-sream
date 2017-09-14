class AddCouponCustomizationFieldsOnCampaign < ActiveRecord::Migration

  def up
    add_column :campaigns, :color_scheme, :text
    add_column :campaigns, :logo_file_name, :string
    add_column :campaigns, :logo_content_type, :string
    add_column :campaigns, :logo_file_size, :integer
    add_column :campaigns, :promo_image_file_name, :string
    add_column :campaigns, :promo_image_content_type, :string
    add_column :campaigns, :promo_image_file_size, :integer
    add_column :campaigns, :terms, :text
    add_column :campaigns, :address, :text
    add_column :campaigns, :subject, :string
  end

  def down
    remove_column :campaigns, :subject
    remove_column :campaigns, :address
    remove_column :campaigns, :terms
    remove_column :campaigns, :promo_image_file_size
    remove_column :campaigns, :promo_image_content_type
    remove_column :campaigns, :promo_image_file_name
    remove_column :campaigns, :logo_file_size
    remove_column :campaigns, :logo_content_type
    remove_column :campaigns, :logo_file_name
    remove_column :campaigns, :color_scheme
  end
end
