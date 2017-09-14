class RemoveSomePaperclipReferences < ActiveRecord::Migration
  def up
    remove_column :businesses, :coupon_logo_file_name
    remove_column :businesses, :coupon_logo_content_type
    remove_column :businesses, :counpon_logo_file_size
    remove_column :businesses, :type
  end

  def down
  end
end
