KD::Application.routes.draw do

  resources :companies
  resources :locations
  resources :streams

  namespace :payments do
    resources :customers do
      get 'client_token', on: :member
    end
  end
  get "/checkout", to: 'checkout#checkout', as: :checkout
  get "/checkout/cr_card_confirm", to: 'checkout#cr_card_confirm', as: :cr_card_confirm
  post "/checkout/set_tr", to: 'checkout#set_tr', as: :set_tr


  devise_for :partners, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :dispatches, only: [:index, :create]
  resources :notifications, only: [:index, :create]

  get '/materials/:id', to: 'materials#share', as: :materials_share
  get '/materials/download/:id', to: 'materials#download', as: :download_material

  resource :shopping_cart, :only => [:show] do
    resources :items, only: [:create, :destroy], controller: :shopping_cart_items do
      get 'add_from_iframe', on: :collection, to: "shopping_cart_items#create"
    end
    get 'save_amount'
  end

  devise_for :partners, :controllers => {
    :sessions => "partners/sessions",
    #:registrations => "partners/registrations",
    :passwords => "partners/passwords"
  }

  resources :orders

  get "/partners/demo/buckscountyalive/", :to => "demonstrations#iframe_all_order", :as => "partner"
  get "/partners/demo/buckscountyalive/business/", :to => "demonstrations#iframe_business"
  get "/partners/business/list/", :to => "demonstrations#iframe_business_list"


  resources :stockphotos
  match '/photos/:category', :to => 'stockphotos#category'
  match '/photos', :to => 'stockphotos#category'

  mount Attachinary::Engine => "/attachinary"

  ensure_admin = lambda do |request|
    request.env['warden'].authenticated?(:merchant) and request.env['warden'].user(:merchant).is_admin?
  end

  constraints ensure_admin do
    mount Resque::Server, at: "/resque/web"
    #mount RailsAdmin::Engine => '/rails_admin', :as => 'rails_admin'

    namespace :admin do
      root :to => "consumers#index"
      get 'data' => 'charts#data'
      resources :consumers, :businesses, :campaigns, :referrals, :partners
      resources :merchants do
        get 'campaign_stats/:campaign_id' => 'merchants#campaign_stats'
      end
    end
  end

  Devise.router_name = :main_app

  match '/category/all-offers/philadelphia/:tag', :to => 'categories#show', :as => :categories_show
  match '/category/all-offers', :to => 'categories#show_all', :as => :categories_show_all
  match '/category/partner/:slug', :to => 'categories#show_partner', :as => :categories_show_partner

  get "/businesses/:id/offers", :to => "categories#show_all", :as => :categories_show_business_all
  match '/businesses/examples', :to => 'businesses#examples'
  match '/businesses/list', :to => 'categories#business_list'

  devise_for :consumers, :controllers => {
    :sessions => "consumers/sessions",
    :registrations => "consumers/registrations",
    :passwords => "consumers/passwords",
    :omniauth_callbacks => "consumers/omniauth_callbacks"
  }

  devise_for :merchants, :controllers => {
    :sessions => "merchants/sessions",
    :registrations => "merchants/registrations",
    :passwords => "merchants/passwords"
  }

  controller :coupons do
    get '/coupons' => 'coupons#index'
  end

  namespace :merchants do
    resource :contact_us, :only => ["new", "create"]
    resources :companies
  end
  namespace :consumers do

    controller :application  do
      get '/login', :action => 'login', :as => 'consumerlogin'
      get '/signup_form', :action => 'signup_form', :as => 'signup_form'
    end

    controller :dashboard  do
      get '/dashboard' => 'dashboard#index'
      get '/dashboard' => 'dashboard#index'
      get '/directions' => 'dashboard#directions'
    end

    controller :picks do
      get '/offers' => 'picks#index', :as => 'offers'
      get '/offers/subscribe' => 'picks#subscribe'
      get '/offers/myhotspots' => 'picks#myhotspots'
      get '/offers/for_business/:id' => 'picks#for_business'
      get '/offers/:id' => 'picks#show', as: 'show_offer'
    end

    resources :businesses, :only => [:index, :show] do
      member do
        post 'toggle_subscription' => 'businesses#toggle_subscription'
        #get 'toggle_subscription' => 'businesses#toggle_subscription'
      end
    end

    resources :locations

    controller :mobile_confirmations do
      get '/mobile/view', :action => 'view', :as => 'send_mobile_confirmation_token'
      get '/mobile/confirm/:confirmation_code', :action => 'confirm', :as => 'mobile_confirmation'
      post '/mobile/confirm', :action => 'confirm', :as => 'mobile_confirmation'
    end
  end

  resource :consumer, :controller => "consumers/consumer" do
    post :update_location, :action => 'update_location', :on => :collection
    get :toggle_email_weekly
    post :toggle_email_weekly
    get :confirm_email
    get :buy_coupon
    post :buy_coupon
    get :transactions
    get :coupon_purchase_status
    get :complete_registration


  end

  resources :customer, :only => [:new, :edit]
  resources :credit_card_info, :only => [:new, :edit, :destroy]
  match '/credit_card_info/:id/set_default' => 'credit_card_info#set_default', :as => :set_default_credit_card

  #get "/credit_card_info/edit_default", to: 'credit_card_info#edit_default', as: :edit_default_credit_card_info

  match 'customer/confirm' => 'customer#confirm', :as => :confirm_customer
  match 'credit_card_info/confirm' => 'credit_card_info#confirm', :as => :confirm_credit_card_info

  match '/consumers/transactions/new' => 'transactions#new', :as => :new_transaction
  match '/consumers/transactions/new_paypal' => 'transactions#new_paypal', :as => :new_paypal_transaction
  match '/consumers/transactions/:id/show' => 'consumers/consumer#show_transaction', :as => :show_transaction
  match '/consumers/transactions/confirm/' => 'transactions#confirm', :as => :confirm_transaction
  match '/consumers/transactions/confirm_paypal/' => 'transactions#confirm_paypal', :as => :confirm_paypal_transaction

  match '/consumers/receipts/:id/show' => 'consumers/consumer#show_receipt', :as => :show_receipt


  post "/set_current_business" => "merchants/application#set_current_business"

  get '/merchants/login' => 'merchants/application#login'
  match '/business/:id/upload_image' => 'businesses#upload_image', :as => :upload_business_image
  match '/business/:id/images' => 'businesses#images', :as => :business_images
  match '/business/:id/add_images' => 'businesses#add_images', :as => :business_add_images

  resources :businesses do

    collection do
      get 'activation'
      post 'activation'
      get 'redeem'
    end

    member do
      get 'oauth_connect'
      get 'oauth_callback'
      get 'facebook_oauth_connect'
      get 'facebook_oauth_callback'
      get 'reset_social'
    end
  end

  resource :account do
    collection do
      post :upgrade
    end
  end

  resources :campaigns do
    member do
      get :recipient_demographics
      get :statistics
      get :campaign_data
      get :sales
    end
    collection do
      match :count_recipients
      get :scheduled
      get :delivered
    end
  end

  resources :companies, only: [:index, :show]

  get '/pages/dollarhood_for_business/' => "pages#dollarhood_for_business", :as => "page_business"
  match '/pages/:action', :controller => "pages", :as => "pages"
  root :to => 'companies#index'

  controller :dashboard do
    get '/dashboard' => 'dashboard#index'
    get '/dashboard/demographics/:group' => 'dashboard#demographics'
  end

  match '/coupons/redeem'    => "coupons#redeem",  :as => "redeem_coupon", :via => [:get, :post]
  get   '/coupons/preview'   => "coupons#preview"
  post  '/coupons/hook'      => "coupons#hook"
  get   '/coupons/:code'     => "coupons#view",    :as => "view_coupon"
  get   '/coupons_json/:code' => "coupons#view_json", :as => 'view_coupon_json'

  resource :contact_us, :only => ["new", "create"]
  match '*a', :to => 'errors#error_404'
  #get '/businesses/croplogo/:id' => 'businesses#crop'
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
