class MerchantsSubscriptionPlans < ActiveRecord::Migration
  def change
    product_id = Account.available_plans.keys.first

    Merchant.update_all({:subscription_plan => product_id})
  end
end
