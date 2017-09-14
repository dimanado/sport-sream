class Merchants::SessionsController < Consumers::SessionsController
  before_filter :authenticate_merchant!, :except => [:login, :new, :create]
  skip_before_filter :require_no_authentication, :only => [:new, :create]
 
  def after_sign_in_path_for(resource)
    new_campaign_path
  end
  def new
    render layout: 'sign_pages'
  end
  def layout_by_request
    if merchant_signed_in?
      "merchants"
    else
      "pages"
    end
  end

end
