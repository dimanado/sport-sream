class CampaignsController < Merchants::ApplicationController
  before_filter :authenticate_merchant!

  before_filter do
    @business = current_business
  end

  before_filter :instantiate_campaign!, :except => [:index, :show, :update, :delete, :campaign_data]

  def index
    @scheduled_campaigns = current_business.campaigns.queued rescue nil
    @delivered_campaigns = current_business.campaigns.delivered_or_expired.sorted rescue nil
  end

  def create
    puts " entering campaign#create "

    # add hashtags
    params[:hashtags].scan(/#\w+/).each do |tag|
      hashtag = Hashtag.find_or_create_by_tag(tag)
      @campaign.coupon.hashtags << hashtag
    end

    set_sharing_option if params[:share]
    if @campaign.save
      puts "  about to enqueue  id #{@campaign.id} "
      puts 'STATE'

      @campaign.enqueue!

      puts "state assigned"
      @campaign.save!

      SocialNetworkShare.start_jobs(@campaign, @business)
      flash[:success] = true
      redirect_to campaigns_path, notice: "Congratulations, you just added a new offer."
    else
      render :action => :new, :status => 422
    end
  end

  def new

  end

  def edit
    @campaign = current_merchant.campaigns.find(params[:id])
  end

  def update
    @campaign = current_merchant.campaigns.find(params[:id])
    @campaign.attributes = params[:campaign]
    set_sharing_option if params[:share]

    # remove previous hashtags
    @campaign.coupon.hashtags = []
    # add current hashtags
    params[:hashtags].scan(/#\w+/).each do |tag|
      hashtag = Hashtag.find_or_create_by_tag(tag)
      @campaign.coupon.hashtags << hashtag
    end

    @campaign.expires_at = DateTime.now + 30.days if @campaign.expires_at > DateTime.now + 7.days
    @campaign.deliver_at = DateTime.now + 1.minute if @campaign.deliver_at < DateTime.now + 1.minute

    if @campaign.save
      unless params[:campaign][:image].nil?
        @campaign.coupon.thumb = Cloudinary::Utils.cloudinary_url(@campaign.image.path,transformation:'offer')
        @campaign.coupon.save

        redirect_to edit_campaign_path(@campaign)
      else
        puts "  about to enqueue  id #{@campaign.id} "
        @campaign.enqueue!
        redirect_to campaigns_path
      end
    else
      render :action => :edit, :status => 422
    end
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    flash[:notice] = "Campaign has been removed."
    redirect_to(params[:redirect_to] || :back)
  end

  def statistics
    @campaign = current_merchant.campaigns.find(params[:id])
  end

  def sales
    coupon = Campaign.find(params[:id]).coupon
    #@entries = ShowsSalesForCoupon.generate(coupon)
  end

  def campaign_data
    campaign = Campaign.find(params[:id])
    render :json => { :coupon => campaign.coupon, :target => campaign.target    }
  end

  def count_recipients
    render :json => {:count => pluralize(@campaign.matched_consumer_count, "Recipient")  }
  end

  def recipient_demographics
    campaign = @business.campaigns.find(params[:id])
    demographics = Target.age_bracket_counts_by_gender(campaign.recipients)
    render :json => {demographics: demographics}
  end

  private


  def pluralize(count, singular)
    count.to_s + ' ' + (count == 1 ? singular : singular.pluralize)
  end

  def instantiate_campaign!
    if params[:id]
      @campaign = @business.campaigns.find(params[:id])
    else
      @campaign = @business.campaigns.new
    end
    @campaign.attributes = params[:campaign]
    @campaign.build_coupon if @campaign.coupon.nil?
    @campaign.coupon.inspect
  end

  def set_sharing_option
    @campaign.twitter_share = params[:share][:twitter].present? ? '1d' : nil
    @campaign.facebook_share = params[:share][:facebook].present? ? '1d' : nil
  end
end
