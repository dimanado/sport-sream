class ReferralMakeKeyString < ActiveRecord::Migration
  def change
    change_column :referrals, :refkey, :string
  end
end
