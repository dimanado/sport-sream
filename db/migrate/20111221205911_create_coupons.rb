class CreateCoupons < ActiveRecord::Migration
  def up
    create_table :coupons do |t|
      t.belongs_to :campaign
      t.string  :subject
      t.text    :content
      t.text    :color_scheme
      t.string  :logo_file_name
      t.string  :logo_content_type
      t.integer :logo_file_size
      t.string  :promo_image_file_name
      t.string  :promo_image_content_type
      t.integer :promo_image_file_size
      t.text    :terms
      t.text    :address
    end
    remove_column :campaigns, :subject
    remove_column :campaigns, :coupon_content
    remove_column :campaigns, :color_scheme
    remove_column :campaigns, :logo_file_name
    remove_column :campaigns, :logo_content_type
    remove_column :campaigns, :logo_file_size
    remove_column :campaigns, :promo_image_file_name
    remove_column :campaigns, :promo_image_content_type
    remove_column :campaigns, :promo_image_file_size
    remove_column :campaigns, :terms
    remove_column :campaigns, :address

    add_index :coupons, :campaign_id
  end

  def down
    add_column :campaigns, :address, :text
    add_column :campaigns, :terms, :text
    add_column :campaigns, :promo_image_file_size, :integer
    add_column :campaigns, :promo_image_content_type, :string
    add_column :campaigns, :promo_image_file_name, :string
    add_column :campaigns, :logo_file_size, :integer
    add_column :campaigns, :logo_content_type, :string
    add_column :campaigns, :logo_file_name, :string
    add_column :campaigns, :color_scheme, :string
    add_column :campaigns, :coupon_content, :text
    add_column :campaigns, :subject, :string
    drop_table :coupons
    remove_index :coupons, :campaign_id
  end
end
