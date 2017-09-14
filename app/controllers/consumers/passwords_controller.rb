class Consumers::PasswordsController < Devise::PasswordsController
  layout :layout_by_request
  def layout_by_request
#    if is_mobile_request?
#      "consumers/public"
#    else
      "fullscreen"
#    end
  end

  def after_sign_in_path_for(resource)
    if params[:fancylogin]
      consumers_offers_path
    else
      stored_location_for(resource) || consumers_dashboard_path
    end
  end
end
