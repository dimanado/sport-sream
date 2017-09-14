ActiveAdmin.register Business do

  index do
    column(:id)
    column "Business" do |business|
      link_to business.name, admin_business_path(business)
    end
    column "Merchant's Name" do |business|
      link_to business.merchant.name, admin_merchant_path(business.merchant)
    end
    column "Merchant's Email" do |business|
      link_to business.merchant.email, admin_merchant_path(business.merchant)
    end
    column(:campaigns) do |business|
      text_node business.campaigns.count
    end
    column "Offers sold" do |business|
      offers_sold_count = 0
      business.campaigns.each do |campaign|
        offers_sold_count = campaign.coupon.sold_count
      end
      text_node offers_sold_count
    end
    # DHW-20--Business - Subscriber Column
    #column "Subscribes" do |business|
    #	text_node business.subscriptions.count
    #end
    column "Monthly Revenue" do |business|
      text_node '$'
      text_node business.monthly_revenue.round 2
    end

    if current_partner.role?('admin')
      column "Sharing on Facebook" do |business|
        if business.has_facebook_credentials?
          text_node 'yes'
        else
          text_node 'no'
        end
      end
      column "Sharing on Twitter" do |business|
        if business.has_twitter_credentials?
          text_node 'yes'
        else
          text_node 'no'
        end
      end
    end

  end

  show do |business|
    attributes_table do
      row "Merchant's name" do
        business.merchant.name
      end
      row "Merchant's email" do
        business.merchant.email
      end
      row :created_at
      row :location
      row :address
      row :city
      row :state
      row :zip_code
      row :phone
      row :description
    end
    text_node "Campaigns"
    table_for business.campaigns do
      column :created_at
      column "Subject" do |campaign|
        text_node campaign.coupon.subject
      end
      column "content" do |campaign|
        text_node campaign.coupon.content
      end
      column "Offers sold" do |campaign|
        offers_sold_count = campaign.coupon.sold_count
        text_node offers_sold_count
      end
      column "Revenue" do |campaign|
        text_node '$'
        text_node campaign.total_revenue.round 2
      end
    end
  end

  #	def get_revenue(campaign, start_date = Date.new(1998), end_date = DateTime.now)
  #		transactions = ShoppingCartItem.find_by_item_id(campaign.coupon.id)
  #		requested_transactions = transactions.where(:created_at => start_date..end_date)
  #		revenue = 0

  #		requested_transactions.each do |transaction|
  #			revenue += transaction.price*transaction.quantity
  #		end

  #		return revenue
  #	end

  filter :merchant, :collection => proc {current_partner.role == 'admin' ? Merchant.all : Merchant.select {|m| m.partner.present? && m.partner.id == current_partner.id}}
  filter :name
  filter :location
  filter :city
  filter :state
  filter :zip_code
  filter :categories_id, :collection => proc { Category.all}, :as => :check_boxes, :multiple => true, :label => "Category"
  filter :address
  filter :name_or_categories_name_cont, :label => "Keyword"
end
