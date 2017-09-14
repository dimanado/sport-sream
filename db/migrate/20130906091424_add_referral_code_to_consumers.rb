class AddReferralCodeToConsumers < ActiveRecord::Migration
  def change
    add_column :consumers, :referral_code, :string
    remove_column :consumers, :mobile_confirmation_token
    remove_column :consumers, :mobile_confirmed_at
    remove_column :consumers, :mobile_confirmation_sent_at
  end
end
