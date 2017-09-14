class AddFacebookPageIdentifierToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :facebook_page_identifier, :string
    add_column :businesses, :facebook_page_access_token, :string
  end
end
