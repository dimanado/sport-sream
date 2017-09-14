class CouponsController < Merchants::ApplicationController
  before_filter :authenticate_merchant!
  skip_before_filter :authenticate_merchant!, :only => [:view, :view_json, :hook, :index]

  layout :layout_by_request

  def view
    @coupon = Coupon.find_by_code(params[:code])
    if @coupon.nil?
      Rails.logger.debug 'COUPON NOT FOUND'
      return render(:not_found, :status => 404)
    end
    @campaign = @coupon.campaign
    if @campaign.nil?
      return render(:not_found, :status => 404)
    end
    @coupon.viewed_count += 1
    meta_image(@coupon.thumb)
    meta_description(@coupon.content)
    meta_type('article')
    meta_title("Dollarhood Offer from #{@coupon.business.name} - #{@coupon.subject}")

    if params[:iframe]
      render :layout => 'page_iframe' and return
    end
  end

  def view_json
    @coupon = Coupon.find_by_code(params[:code])
    if @coupon.nil?
      Rails.logger.debug 'COUPON NOT FOUND'
      return render :json => {:success => false, :status => 404}
    end
    @campaign = @coupon.campaign
    if @campaign.nil?
      return render :json => {:success => false, :status => 404}
    end
    @business = @campaign.business
    # @business_logo_url = business.logo ? "v#{business.logo.version}/#{business.logo.public_id}" : Rails.root + path_to_image('default_business_logo.png')

    business = {}
    if @business.online_business == '1'
      business[:online_business] = true
    else
      business[:online_business] = false
      business[:city] = @business.city
      business[:address] = @business.address
      business[:state] = @business.state
    end
    business[:id] = @business.id
    business[:name] = @business.name
    business[:website] = @business.website.nil? ? nil : @business.website.downcase
    business[:zip_code] = @business.zip_code
    business[:phone] = @business.phone
    business[:logo] = @business.logo ? "http://res.cloudinary.com/hooditt-com/image/upload/c_fit,h_160,w_240/#{@business.logo.path}" : "/assets/default_business_logo.png"

    consumer_signed_in = false
    if current_consumer
      business[:is_subscribed] = @business.has_subscriber?(current_consumer)
      business[:subscribed] = current_consumer.subscribed_to?(@business)
      consumer_signed_in = true
    else 
      business[:is_subscribed] = false
      business[:subscribed] = false
    end 

    render :json => {
      :business => business,
      :consumer_signed_in => consumer_signed_in,
      :coupon => {
        id: @coupon.id,
        logo: @coupon.thumb,
        subject: @coupon.subject,
        content: @coupon.content,
        code: @coupon.code,
        url: CGI::escape(view_coupon_url(@coupon.code))
        },
      :expires => @campaign.expires_at.to_i
      }
  end

  def layout_by_request
    case action_name
    when "view"
      if consumer_signed_in?
       "consumers/application"
      else
        "pages"
      end
    else
      "coupon"
    end
  end

  def index
    @campaigns = Campaign.where('expires_at > ?', Time.zone.now).where('deliver_at < ?', Time.zone.now)
  end

  def preview
    @preview = true
    params[:campaign] && params[:campaign].delete(:target_attributes)

    if params[:id]
      @campaign = current_merchant.campaigns.find(params[:id])
    else
      @campaign = Campaign.new
    end
    @campaign.attributes = params[:campaign]
    @coupon = @campaign.coupon || @campaign.build_coupon
    @coupon.business = current_business
     if params[:campaign]
      @campaign.expires_at = Date.new(params[:campaign]["expires_at(1i)"].to_i,params[:campaign]["expires_at(2i)"].to_i,params[:campaign]["expires_at(3i)"].to_i)
    else
      @campaign.expires_at = DateTime.now +7
    end
    render :phone_preview
  end

end
