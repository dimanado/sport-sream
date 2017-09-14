class ReferralRenameKeyColumn < ActiveRecord::Migration
  def change
    rename_column :referrals, :key, :refkey
  end
end
