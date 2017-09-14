class Partners::RegistrationsController < Devise::RegistrationsController


  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :partner && (action_name == 'new' or action_name == 'create')
      "pages"
    else
      "partners"
    end
  end

  def create
    puts "Maxim -- PARTNERS -- REGISTRATIONS_CONTROLLER -- VIA BACK END ONLY"
  end


  def new
    render :layout => "fullscreen"
  end

  private

  def after_update_path_for(resource)
    edit_partner_registration_path(resource)
  end
end
