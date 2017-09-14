class Partners::ApplicationController < ApplicationController

  layout :layout_by_resource
  before_filter :destroy_session, :only => [:login, :signup_form], :if => :partner_signed_in?
  before_filter :set_app_session

  def login
    render layout: "fullscreen"
  end

  protected

    def destroy_session
      sign_out current_partner
    end

    def set_app_session
      session[:app] ||= params[:app]
    end 

    def layout_by_resource
      if partner_signed_in?
        "partners"
      else
        "pages"
      end
    end

end
