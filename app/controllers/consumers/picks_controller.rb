class Consumers::PicksController < Consumers::ApplicationController

  def index

    @category_data = GeneratesCategoriesForSelect.generate(Category.top_level)

    return by_search if params[:keyword] || params[:dist]
    puts current_consumer.all_offers.map(&:id)

    generate_entries(current_consumer.all_offers)

    puts @offers.to_yaml

    dist = 300

    @offers = Consumer.near(current_consumer.location, dist, @offers)

    @type = 'all'
    render "index"
  end

  def by_search
    matching_offers = Campaign.all
    unless params[:keyword].blank?
      if params[:keyword].start_with? '#'
        # search in hashtags only
        matching_offers.select! {|offer| offer.hashtags.any? {|hashtag| hashtag.tag.include? params[:keyword]}}
      else
        matching_offers.select! {|offer| offer.business.name.include? params[:keyword] or
          offer.business.categories.any? {|category| category.name.include? params[:keyword]} or
          offer.coupon.subject.include? params[:keyword] or
          offer.coupon.content.include? params[:keyword] or
        offer.hashtags.any? {|hashtag| hashtag.tag.include? params[:keyword]}}
      end
    end
    unless params[:dist].blank?
      matching_offers = Consumer.near(current_consumer.location, params[:dist].to_i, matching_offers)
    else
      # 300 miles by default
      dist = 300
      matching_offers = Consumer.near(current_consumer.location, dist, matching_offers)
    end
    generate_entries(matching_offers)
    @type = 'all'
    render 'index'
  end

  def show
    @offer = Campaign.find(params[:id])
  end

  def for_business
    business = Business.find_by_name(params[:business_name])
    generate_entries(business.campaigns.active)
    render 'index'
  end

  def subscribe
    @businesses = Business
    .with_campaign_counts
    .includes(:logo_files)
    .includes(:subscriptions)
    .includes(:merchant)

    dist = 300

    if params[:dist].present?
      dist = params[:dist].to_i
    end

    @businesses_filtered = @businesses
    .near(current_consumer.location, dist)
    .select {|b| not b.merchant.is_admin? }

    if params[:business_name].present?
      @businesses_filtered = @businesses_filtered
      .select {|b| b.name.include? params[:business_name]}
    end

    if params[:cat_id].present?
      @businesses_filtered = @businesses_filtered
      .select{|b| b.categories.include? Category.find(params[:cat_id]) }
    end

    @only_followed = false

    @businesses = Kaminari.paginate_array(@businesses_filtered).page(params[:page]).per(21)

    @category_data = GeneratesCategoriesForSelect.generate(Category.top_level)
  end

  def myhotspots
    @businesses = Business
    .with_campaign_counts
    .includes(:logo_files)
    .includes(:subscriptions)
    .includes(:merchant)

    dist = 300

    if params[:dist].present?
      dist = params[:dist].to_i
    end

    @businesses_filtered = @businesses
    .near(current_consumer.location, dist)
    .select {|b| not b.merchant.is_admin? }

    if params[:business_name].present?
      @businesses_filtered = @businesses_filtered
      .select {|b| b.name.include? params[:business_name]}
    end

    if params[:cat_id].present?
      @businesses_filtered = @businesses_filtered
      .select{|b| b.categories.include? Category.find(params[:cat_id]) }
    end

    @businesses_filtered = @businesses_filtered.select {|b| b.subscribers.include? current_consumer}

    @businesses = Kaminari.paginate_array(@businesses_filtered).page(params[:page]).per(21)
    @only_followed = true

    @category_data = GeneratesCategoriesForSelect.generate(Category.top_level)

    render 'subscribe'
  end

end
