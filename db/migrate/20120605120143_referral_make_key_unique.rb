class ReferralMakeKeyUnique < ActiveRecord::Migration
  def change
    change_column :referrals, :key, :string, :null => false
  end
end
