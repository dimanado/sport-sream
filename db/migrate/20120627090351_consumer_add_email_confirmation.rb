class ConsumerAddEmailConfirmation < ActiveRecord::Migration
  def up
  	add_column :consumers, :email_confirmed, :boolean, :default => true
  end

  def down
  	remove_column :consumers, :email_confirmed
  end
end
