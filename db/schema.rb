# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20170915132352) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "attachinary_files", :force => true do |t|
    t.integer  "attachinariable_id"
    t.string   "attachinariable_type"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "attachinary_files", ["attachinariable_type", "attachinariable_id", "scope"], :name => "by_scoped_parent"

  create_table "businesses", :force => true do |t|
    t.integer  "merchant_id"
    t.string   "name"
    t.string   "location"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code",                   :null => false
    t.string   "phone"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "access_token"
    t.string   "secret_token"
    t.string   "facebook_access_token"
    t.string   "facebook_page_identifier"
    t.string   "facebook_page_access_token"
    t.string   "website"
    t.text     "description"
    t.string   "coupon_logo_file_name"
    t.string   "coupon_logo_content_type"
    t.integer  "counpon_logo_file_size"
    t.string   "online_business"
  end

  add_index "businesses", ["merchant_id"], :name => "index_businesses_on_merchant_id"

  create_table "businesses_categories", :id => false, :force => true do |t|
    t.integer "business_id"
    t.integer "category_id"
  end

  add_index "businesses_categories", ["business_id"], :name => "index_businesses_categories_on_business_id"
  add_index "businesses_categories", ["category_id"], :name => "index_businesses_categories_on_category_id"

  create_table "businesses_companies", :id => false, :force => true do |t|
    t.integer "business_id"
    t.integer "company_id"
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "business_id"
    t.datetime "deliver_at"
    t.datetime "expires_at"
    t.string   "message_content"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "state"
    t.datetime "deleted_at"
    t.string   "facebook_share"
    t.string   "twitter_share"
  end

  add_index "campaigns", ["business_id"], :name => "index_campaigns_on_business_id"
  add_index "campaigns", ["deliver_at"], :name => "index_campaigns_on_deliver_at"
  add_index "campaigns", ["expires_at"], :name => "index_campaigns_on_expires_at"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "tag"
  end

  create_table "companies", :force => true do |t|
    t.string "title"
    t.string "description"
  end

  create_table "companies_merchants", :id => false, :force => true do |t|
    t.integer "merchant_id"
    t.integer "company_id"
  end

  create_table "consumer_accounts", :force => true do |t|
  end

  create_table "consumers", :force => true do |t|
    t.string   "name"
    t.string   "email",                                                                            :null => false
    t.string   "mobile"
    t.text     "braintree_customer_id"
    t.string   "carrier"
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.integer  "birth_year"
    t.string   "gender",                      :limit => 1
    t.boolean  "optin"
    t.boolean  "enabled"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "encrypted_password",          :limit => 128, :default => "",                       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "message_delivery_preference",                :default => "DeliveryChannel::Email", :null => false
    t.string   "location"
    t.integer  "referral_id"
    t.boolean  "weekly_digest",                              :default => true
    t.boolean  "email_confirmed",                            :default => true
    t.string   "type",                                       :default => "Consumer",               :null => false
    t.integer  "imported_by",                                :default => 0,                        :null => false
    t.string   "referral_code"
    t.string   "uid"
    t.string   "provider"
  end

  add_index "consumers", ["email"], :name => "index_consumers_on_email", :unique => true
  add_index "consumers", ["reset_password_token"], :name => "index_consumers_on_reset_password_token", :unique => true

  create_table "coupon_codes", :force => true do |t|
    t.integer  "consumer_id"
    t.integer  "coupon_id"
    t.integer  "transaction_id"
    t.string   "code",                              :null => false
    t.boolean  "redeemed",       :default => false, :null => false
    t.datetime "purchase_date"
  end

  add_index "coupon_codes", ["consumer_id"], :name => "index_coupon_codes_on_consumer_id"
  add_index "coupon_codes", ["coupon_id"], :name => "index_coupon_codes_on_coupon_id"
  add_index "coupon_codes", ["transaction_id"], :name => "index_coupon_codes_on_transaction_id"

  create_table "coupons", :force => true do |t|
    t.integer "campaign_id"
    t.string  "subject"
    t.text    "content"
    t.text    "terms"
    t.text    "address"
    t.integer "amount",       :default => -1, :null => false
    t.string  "code"
    t.integer "sold_count",   :default => 0,  :null => false
    t.integer "viewed_count", :default => 0,  :null => false
    t.string  "thumb"
    t.text    "more_terms"
    t.string  "promo_code"
  end

  add_index "coupons", ["campaign_id"], :name => "index_coupons_on_campaign_id"

  create_table "coupons_hashtags", :id => false, :force => true do |t|
    t.integer "coupon_id"
    t.integer "hashtag_id"
  end

  create_table "delivery_channels", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "delivery_channels", ["campaign_id"], :name => "index_delivery_channels_on_campaign_id"

  create_table "dispatch_recipients", :force => true do |t|
    t.string   "email"
    t.string   "status"
    t.integer  "dispatch_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "dispatch_recipients", ["dispatch_id"], :name => "index_dispatch_recipients_on_dispatch_id"

  create_table "dispatches", :force => true do |t|
    t.integer  "partner_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "dispatches", ["partner_id"], :name => "index_dispatches_on_partner_id"

  create_table "dispatches_materials", :id => false, :force => true do |t|
    t.integer "dispatch_id"
    t.integer "material_id"
  end

  create_table "hashtags", :force => true do |t|
    t.text     "tag"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name",                     :null => false
    t.string   "zip_code",    :limit => 5, :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "consumer_id"
    t.integer  "company_id"
  end

  add_index "locations", ["consumer_id"], :name => "index_locations_on_consumer_id"

  create_table "material_downloads", :force => true do |t|
    t.integer  "partner_id"
    t.integer  "material_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "material_downloads", ["material_id"], :name => "index_material_downloads_on_material_id"
  add_index "material_downloads", ["partner_id"], :name => "index_material_downloads_on_partner_id"

  create_table "materials", :force => true do |t|
    t.string  "title"
    t.string  "type_of_file",                    :null => false
    t.boolean "public",       :default => false
  end

  add_index "materials", ["type_of_file"], :name => "index_materials_by_type"

  create_table "merchants", :force => true do |t|
    t.string   "email",                                 :default => "",      :null => false
    t.string   "name"
    t.string   "encrypted_password",     :limit => 128, :default => "",      :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.boolean  "is_admin",                              :default => false
    t.date     "ibilling_date"
    t.string   "subscription_plan",                     :default => "basic", :null => false
    t.integer  "partner_id"
  end

  add_index "merchants", ["email"], :name => "index_merchants_on_email", :unique => true
  add_index "merchants", ["partner_id"], :name => "index_merchants_on_partner_id"
  add_index "merchants", ["reset_password_token"], :name => "index_merchants_on_reset_password_token", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "recipient_id"
    t.string   "type"
    t.boolean  "delivered"
    t.datetime "opened_at"
    t.datetime "redeemed_at"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "state"
    t.string   "redemption_code"
    t.integer  "viewed_count",    :default => 0
    t.integer  "redeemed_count",  :default => 0
  end

  create_table "notifications", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.string   "status",         :default => "sent", :null => false
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "recipient_type", :default => 0
    t.boolean  "send_via_email", :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "notifications", ["recipient_id"], :name => "index_notifications_on_recipient_id"
  add_index "notifications", ["sender_id"], :name => "index_notifications_on_sender_id"

  create_table "orders", :force => true do |t|
    t.integer  "offer_id"
    t.integer  "consumer_id"
    t.text     "status"
    t.text     "transaction_id"
    t.text     "redemption_code"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "partner_id"
  end

  add_index "orders", ["consumer_id"], :name => "index_orders_on_consumer_id"
  add_index "orders", ["offer_id"], :name => "index_orders_on_offer_id"
  add_index "orders", ["partner_id"], :name => "index_orders_on_partner_id"

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "slug"
    t.string   "url"
    t.string   "contact_info"
    t.integer  "revenue_share",          :default => 50
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.string   "encrypted_password",     :default => "",        :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role",                   :default => "partner"
  end

  add_index "partners", ["email"], :name => "index_partners_on_email", :unique => true
  add_index "partners", ["name"], :name => "index_partners_on_name", :unique => true
  add_index "partners", ["reset_password_token"], :name => "index_partners_on_reset_password_token", :unique => true
  add_index "partners", ["slug"], :name => "index_partners_on_slug", :unique => true

  create_table "referrals", :force => true do |t|
    t.string   "name"
    t.string   "refkey",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shopping_cart_items", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "quantity"
    t.integer  "item_id"
    t.string   "item_type"
    t.float    "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shopping_carts", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "consumer_id"
    t.string   "status"
    t.string   "redemption_code"
    t.integer  "partner_id"
    t.integer  "quantity_all"
  end

  add_index "shopping_carts", ["consumer_id"], :name => "index_shopping_carts_on_consumer_id"
  add_index "shopping_carts", ["partner_id"], :name => "index_shopping_carts_on_partner_id"

  create_table "stockphotos", :force => true do |t|
    t.string   "img"
    t.string   "category"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "thumb"
  end

  create_table "streams", :force => true do |t|
    t.string  "title"
    t.string  "link"
    t.integer "location_id"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "business_id"
    t.integer  "consumer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "subscriptions", ["business_id"], :name => "index_subscriptions_on_business_id"
  add_index "subscriptions", ["consumer_id"], :name => "index_subscriptions_on_consumer_id"

  create_table "transactions", :force => true do |t|
    t.string   "braintree_transaction_id"
    t.integer  "consumer_id"
    t.integer  "shopping_cart_id"
    t.decimal  "amount",                   :precision => 10, :scale => 2
    t.string   "status"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "express_token"
    t.string   "express_payer_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "paypal_transaction_id"
  end

  create_table "ziplocations", :force => true do |t|
    t.string "zip_code"
    t.float  "latitude"
    t.float  "longitude"
  end

end
