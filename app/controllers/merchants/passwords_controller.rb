class Merchants::PasswordsController < Devise::PasswordsController
  layout 'fullscreen'

  def after_sign_in_path_for(resource)
    dashboard_path
  end
end
