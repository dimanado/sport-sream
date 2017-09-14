class Consumers::BusinessesController < Consumers::ApplicationController

  before_filter :get_categories, except: %w[toggle_subscription show]

  add_breadcrumb "Businesses", :consumers_businesses_path

  def index
    @businesses = Business.near(current_consumer.location, 100)
    @businesses = filter_by_subscription_type(params[:subscription_filter], @businesses)
    @businesses = filter_by_business_name(params[:business_name], @businesses)
    @businesses = filter_by_category(@category, @businesses)
  end

  def show
    @business = Business.find(params[:id])
    @campaigns = @business.campaigns.where(:state => 'delivered')

    @all_businesses = @business.merchant.businesses.where('id != ?', @business.id).where(:state => 'delivered')
  end

  def toggle_subscription
    @business = Business.find(params[:id])
    puts "Toggle subscription test"
    puts "current consumer subscribed? - #{current_consumer.subscribed_to?(@business)}"
    puts "subscribers count - #{@business.subscribers.count}"
    if current_consumer.subscribed_to?(@business)
      @business.subscribers.delete(current_consumer)
    else
      @business.subscribers << current_consumer
    end
    puts "subscribers count - #{@business.subscribers.count}"

    respond_to do |format|
      format.html { render :nothing => true }
      format.mobile { redirect_to consumers_businesses_path }
      format.js
      format.json
    end
  end

  private
    def get_categories
      @category = Category.find_by_id(params[:category_id])
      @categories = Category.for_grouped_select
    end

    def filter_by_subscription_type(subscription_type, collection = Business.all)
      case subscription_type
      when 'subscribed'
        collection.select {|b| current_consumer.favorites.include?(b) }
      when 'not_subscribed'
        collection.select {|b| !current_consumer.favorites.include?(b) }
      else
        collection
      end
    end

    def filter_by_business_name(business_name, collection = Business.all)
      return collection if business_name.blank?
      collection.select {|b| b.name =~ /^#{business_name}/ }
    end

    def filter_by_category(category, collection = Business.all)
      return collection if category.nil?
      collection.select {|b| b.categories.include?(category) }
    end

end
