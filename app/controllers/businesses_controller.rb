class BusinessesController < Merchants::ApplicationController
  before_filter :authenticate_merchant!, :except => %w[list]
  before_filter :get_business, :except => %w[index new create examples list]

  def index
    @businesses = current_merchant.businesses.all
  end

  def new
    @business = Business.new
    @twitter_client = TwitterClient.new(@business.access_token,
                                        @business.secret_token)
  end

  def create
    @business = current_merchant.businesses.new(params[:business])
    if @business.save
      flash[:success] = "Created #{@business.name}!"
      redirect_to businesses_path
    else
      flash[:error] = "Failed to create business"
      render :new
    end
  end

  def reset_social
    account = params[:account].to_sym
    business = Business.find(params[:id])

    case account
    when :facebook
      business.reset_facebook_credentials
      business.save!

    when :facebook_page
      business.reset_facebook_page
      business.save!

    when :twitter
      business.reset_twitter_credentials
      business.save!

    end

    redirect_to edit_business_path(business)
  end

  def examples

  end

  def crop
    @business = Business.find(params[:id])
  end

  def edit
    logger.debug 'welcome: ' + params.has_key?(:welcome).to_s
    @twitter_client = TwitterClient.new(@business.access_token,
                                        @business.secret_token)
  end

  def update
    if @business.update_attributes(params[:business])
      redirect_to edit_business_path(@business) , :flash => { :success => "Profile complete", :money => true }
    else
      flash[:error] = "Failed to save profile"
      render :edit
    end
  end

  def upload_image
    if @business.update_attributes(params[:business])
      redirect_to new_campaign_path('business_images' => true) , :flash => { :success => "Image uploaded" }
    else
      redirect_to new_campaign_path('business_images' => true) , :flash => { :error => "Failed to save profile" }
    end
  end

  def images
    render :layout => false
  end

  def add_images
    render :layout => 'bare'
  end

  def facebook_oauth_connect
    callback_url = facebook_oauth_callback_business_url(@business)
    redirect_to @business.facebook_client(callback_url).authorization_uri(:scope => [:offline_access, :manage_pages, :publish_stream, :publish_actions])
  end

  def facebook_oauth_callback
    begin
      callback_url = facebook_oauth_callback_business_url(@business)
      @business.facebook_client(callback_url).authorization_code = params[:code]
      authorization = @business.facebook_client.access_token! :client_auth_body # => Rack::OAuth2::AccessToken::Legacy
      @business.facebook_access_token = authorization.access_token
    rescue Exception => e
      flash[:error] = "Could not authorize Facebook: #{e.response.inspect}"
    end

    if @business.facebook_client_authorized?
      flash[:success] = "Successfully authorized Facebook!"
      @business.save
    end
    redirect_to edit_business_path(@business)
  end

  def oauth_connect
    callback_url = oauth_callback_business_url(@business)
    request_token = TwitterLink.request_token(callback_url)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end

  def oauth_callback
    link = TwitterLink.new(session[:request_token],
                           session[:request_token_secret],
                           params[:oauth_verifier])

    if link.authorized?
      @business.access_token = link.access_token.token
      @business.secret_token = link.access_token.secret
      @business.save
      flash[:success] = "Successfully authorized Twitter!"
    else
      flash[:error] = "Failed to authorize to twitter"
    end

    redirect_to edit_business_path(@business)
  end

  private

  def get_business
    @business = current_merchant.businesses.find(params[:id]) rescue nil
  end

end
