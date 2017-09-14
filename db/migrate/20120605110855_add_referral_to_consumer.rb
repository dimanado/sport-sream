class AddReferralToConsumer < ActiveRecord::Migration
  def up
    add_column :consumers, :referral_id, :integer
  end

  def down
    remove_column :consumers, :referral_id
  end
end
