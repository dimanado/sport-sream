class AddDeviseToConsumers < ActiveRecord::Migration
  def change
    change_table(:consumers) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    end

    add_index :consumers, :email,                :unique => true
    add_index :consumers, :reset_password_token, :unique => true
    add_index :consumers, :confirmation_token,   :unique => true
    # add_index :consumers, :unlock_token,         :unique => true
    # add_index :consumers, :authentication_token, :unique => true
  end
end
