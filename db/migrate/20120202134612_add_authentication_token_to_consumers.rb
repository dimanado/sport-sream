class AddAuthenticationTokenToConsumers < ActiveRecord::Migration
  def up
    add_column :consumers, :authentication_token, :string
    add_index :consumers, :authentication_token, :unique => true
  end

  def down
    remove_index :consumers, :authentication_token
    remove_column :consumers, :authentication_token
  end
end
