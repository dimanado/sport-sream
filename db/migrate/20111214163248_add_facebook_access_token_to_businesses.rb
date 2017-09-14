class AddFacebookAccessTokenToBusinesses < ActiveRecord::Migration

  def change
    add_column :businesses, :facebook_access_token, :string
  end
end
