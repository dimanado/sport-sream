class MerchantSubscriptionPlan < ActiveRecord::Migration
  def up
    add_column :merchants, :subscription_plan, :string, :default => 'basic', :null => false
  end

  def down
    remove_column :merchants, :subscription_plan
  end
end
