class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_business
  # helper_method :shopping_cart

  before_filter :set_partner_cookie
  before_filter :set_ip_geocoding_cookie

  def set_partner_cookie
    if params[:partner_slug] and partner = Partner.find_by_slug(params[:partner_slug])
      cookies[:partner_slug] = partner.slug
    end
  end

  def set_ip_geocoding_cookie
    unless c = cookies[:ip_geocoding_cookie] and c = JSON.parse(c) and c["ip"] == request.remote_ip
      c = {
        "ip" => request.remote_ip,
        "coordinates" => request.location.coordinates
      }
      cookies[:ip_geocoding_cookie] = c.to_json
    end

    @current_consumer_location = c["coordinates"]
  end

  def current_consumer_location
    @current_consumer_location ||= request.location.coordinates
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  def all_offers
    Campaign.includes(:coupon).includes(:business => [:logo_files])
    .where('expires_at > ?', Time.zone.now)
    .where('deliver_at < ?', Time.zone.now)
    .select {|c| c.coupon.amount != 0 }
  end

  def all_offers_partner
    Campaign.includes(:coupon).includes(:business)
    .where('expires_at > ?', Time.zone.now)
    .where('deliver_at < ?', Time.zone.now)
    .where('coupons.amount != 0')
    .where('businesses.zip_code IN (?)', ZipCode.bca_zip_codes)
  end

  def verify_zip(zip, zip_arr)
    return(true) if zip_arr.nil?

    zip_arr.each do |z|
      return(true) if zip == z
    end
    false
  end

  def all_offers_business(id)
    Campaign.includes(:coupon).includes(:business)
    .where('expires_at > ?', Time.zone.now)
    .where('deliver_at < ?', Time.zone.now)
    .where(business_id: id)
    .select {|c| c.coupon.amount != 0 }
  end

  def current_business
    begin
      business_id = session[:current_business_id] ||= current_merchant.business_ids.first
      @current_business ||= current_merchant.businesses.find(business_id)
    rescue Exception => e
      @current_business = nil
    end
  end

  def set_current_business
    session[:current_business_id] = current_merchant.business_ids.find{|id| id == params[:business_id].to_i}
    redirect_to campaigns_path
  end


  def after_sign_in_path_for(resource)
    return admin_dashboard_path unless current_partner.blank?
    return session[:consumer_return_to] if session[:consumer_return_to]
    return session[:merchant_return_to] if session[:merchant_return_to]
    return resource == current_merchant ? campaigns_path : edit_consumer_path
  end

  def generate_entries (collection)
    campaigns = filter_by_business(collection)
    campaigns = filter_by_category(campaigns)
    campaigns = filter_by_subcategories(campaigns)
    campaigns = filter_by_hashtag(campaigns)

    @offers = campaigns.select {|c| c.has_available_coupon? }
    .sort_by{|c| c.business.distance_to_latlon(*current_consumer_location).round rescue 9999}
  end

  def filter_by_business (collection)
    return collection unless params[:business_name]
    business_ids = Business.select('id').map(&:id)
    collection.select {|c| business_ids.include?(c.business_id)}
  end

  def filter_by_category (collection)
    return collection unless params[:cat_id]
    category = Category.includes(:children).find(params[:cat_id])
    CategorizesCampaigns.filter_by_category(collection, category)
  end

  def filter_by_subcategories (collection)
    return collection unless params[:cat_ids]
    CategorizesCampaigns.filter_by_subcategories_ids(collection, params[:cat_ids])
  end

  def fetch_new_transparent_redirect_data
    @tr_data = Braintree::TransparentRedirect.
      create_customer_data(:redirect_url => confirm_customer_url(:number => params[:number]))
  end

  def fetch_edit_transparent_redirect_data

    unless current_consumer.with_braintree_data!
      fetch_new_transparent_redirect_data
      return render :action => "new"
    end

    @credit_card = current_consumer.default_credit_card
    @tr_data = Braintree::TransparentRedirect.
      update_customer_data(:redirect_url => confirm_customer_url,
                           :customer_id => current_consumer.braintree_customer_id)
      end

  private

  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/pages', status: status }
      format.all { render nothing: true, status: status }
    end
  end

end
