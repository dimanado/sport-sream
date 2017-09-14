ActiveAdmin.register Consumer do

  index do
    column :id
    column :email
    column :braintree_customer_id
    column :created_at
    column :last_sign_in_at
    column :location
    column :referral_id
    column :weekly_digest
    column :email_confirmed
    column :referral_code
    column :uid
    column :provider
  end

  filter :id
  filter :email
  filter :braintree_customer_id
  filter :location
  filter :referral_id
  filter :weekly_digest, :as => :select
  filter :email_confirmed, :as => :select
  filter :referral_code
  filter :uid
  filter :provider

	menu false
end