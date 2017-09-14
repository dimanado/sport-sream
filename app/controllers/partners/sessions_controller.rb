class Partners::SessionsController <  Devise::SessionsController
  before_filter :authenticate_partner!, :except => [:login, :new, :create]
  skip_before_filter :require_no_authentication, :only => [:new, :create]
 
  #def after_sign_in_path_for(resource)
  #  new_campaign_path
  #end
  def new
    @partner_sign_in = true
    render layout: 'sign_pages'
  end
  def layout_by_request
    if partner_signed_in?
      "partners"
    else
      "pages"
    end
  end


end
