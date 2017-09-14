class DeviseCreateMerchants < ActiveRecord::Migration
  def self.up
    create_table(:merchants) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :merchants, :email,                :unique => true
    add_index :merchants, :reset_password_token, :unique => true
    # add_index :merchants, :confirmation_token,   :unique => true
    # add_index :merchants, :unlock_token,         :unique => true
    # add_index :merchants, :authentication_token, :unique => true
  end

  def self.down
    drop_table :merchants
  end
end
