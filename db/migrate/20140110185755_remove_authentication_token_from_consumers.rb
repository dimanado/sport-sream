class RemoveAuthenticationTokenFromConsumers < ActiveRecord::Migration
  def change
    remove_column :consumers, :authentication_token
  end
end
