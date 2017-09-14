ActiveAdmin.register Campaign do

  state_action :enqueue
  state_action :expire

  index do
    column(:created_at)
    column(:business)
    column "Categories" do |campaign|
      campaign.business.categories.each do |category|
        div :class => "business_categories" do
          link_to(category.name, admin_category_path(category))
        end
      end
    end
    column "Subject" do |campaign|
      link_to(campaign.coupon.subject, admin_campaign_path(campaign))
    end
    column "Hashtags" do |campaign|
      hashtags = ''
      campaign.hashtags.each do |hashtag|
        hashtags += hashtag.tag + ' '
      end
      text_node hashtags
    end
    column "Content" do |campaign|
      text_node campaign.coupon.content
    end
    column :state
    column "Offers sold" do |campaign|
      offers_sold_count = campaign.coupon.sold_count
      text_node offers_sold_count
    end
    column "Revenue" do |campaign|
      text_node '$'
      text_node campaign.total_revenue.round 2
    end
    actions
  end

  filter :business
  filter :created_at
  filter :expires_at
  filter :state, as: :check_boxes, collection: ['passive', 'queued', 'delivered', 'expired']
  filter :hashtags_tag_cont, :label => "Hashtag"
  filter :business_name_or_business_categories_name_cont, :label => "Keyword"

  form do |f|
    f.inputs "Campaign" do
      f.input :business
      f.input :deliver_at
      f.input :expires_at
      f.input :deleted_at
    end
    f.inputs "Coupon" do
      f.fields_for :coupon do |j|
        j.inputs :subject, :content
        #j.has_many :hashtags do |k|
        #  k.input :tag
        #end
      end
    end
    f.actions
  end

=begin
  controller do
    def new
      @campaign = Campaign.new
      @campaign.build_coupon
      @campaign.coupon.build_hashtags
    end
  end
=end

  filter :business
  filter :created_at
  filter :expires_at
  filter :state, as: :check_boxes, collection: ['passive', 'queued', 'delivered', 'expired']
  filter :hashtags_tag_cont, :label => "Hashtag"
  filter :business_name_or_business_categories_name_cont, :label => "Keyword"
end

ActiveAdmin.register Campaign, :namespace => 'super_admin' do
end
