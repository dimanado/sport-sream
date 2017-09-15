class Merchants::RegistrationsController < Devise::RegistrationsController
  # layout "merchants/public"
  ##
  # build the business association
  #


  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :merchant && (action_name == 'new' or action_name == 'create')
      "pages"
    else
      "merchants"
    end
  end

  def create
    @partner = Partner.find_by_slug(params[:partner_slug]) ||
      Partner.find_by_slug(session[:partner]) ||
      Partner.dollarhood
    unless params[:fancysignup]
      @merchant = build_resource
      @business = resource.businesses.build(params[:business])

      if resource.save
        #logger.debug 'HOOD merchant registration created'
        if resource.active_for_authentication?
          #logger.debug 'HOOD resource.active_for_authentication?'
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_in(resource_name, resource)
          #logger.debug 'HOOD signedin #{resource_name}, #{resource}'
          respond_with resource, :location => campaigns_path
        else
          set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
          expire_session_data_after_sign_in!
          respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        end
      else
        respond_with resource, :location => new_merchant_registration_path
      end
    else
      create_ajax
    end
  end

  def create_ajax
    merchant = @partner.merchants.new(params[:merchant])
    business = merchant.businesses.build(params[:business])
    if merchant.errors.any? or !merchant.valid?
      render :json => {
        :success => false,
        :errors => merchant.errors
      }
    else
      build_resource
      merchant.save
      # HooddittMailer.welcome_merchant(merchant.email).deliver!
      sign_in(:merchant, merchant)
      redir_url = edit_business_path(merchant.businesses.first)
      flash[:welcome] = true
      render :json => {
        :success => true,
        :redirect => redir_url

      }
    end
  end

  def new
    render :layout => "sign_pages"
  end

  private

  def after_update_path_for(resource)
    edit_merchant_registration_path(resource)
  end
end
