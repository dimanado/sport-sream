class AddTwitterTokensToBusinesses < ActiveRecord::Migration
  def up
    add_column :businesses, :access_token, :string
    add_column :businesses, :secret_token, :string
  end

  def down
    remove_column :businesses, :secret_token
    remove_column :businesses, :access_token
  end
end
