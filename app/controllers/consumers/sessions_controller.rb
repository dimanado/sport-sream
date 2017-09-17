class Consumers::SessionsController < Devise::SessionsController
  layout :layout_by_request

  def create
    unless params[:fancylogin]
      resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      session[:app] = params[:app]
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      resource = warden.authenticate! :scope => resource_name, :recall => "#{controller_path}#ajax_sign_in_fail"
      ajax_sign_in_success resource_name, resource
    end
  end
  def new
  end
  def after_sign_in_path_for(resource)
    if params[:fancylogin]
      edit_consumer_path
    else
      stored_location_for(resource) || edit_consumer_path
    end
  end

  def ajax_sign_in_success (resource_or_scope, resource = nil)
    scope = Devise::Mapping.find_scope! resource_or_scope
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    Rails.logger.debug "after_sign_in_path_for(resource) = #{after_sign_in_path_for(resource)}"
    render :json => {
      :success => true,
      :redirect => after_sign_in_path_for(resource)
    }
  end

  def ajax_sign_in_fail
    render :json => {
      :sucees => false,
      :errors => ['Invalid email or password.']
    }
  end

  def layout_by_request
#    if is_mobile_request?
#      "consumers/public"
#    else
      consumer_signed_in? ? "consumers/application" : "sign_pages"
#    end
  end

end
