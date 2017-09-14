class Consumers::ApplicationController < ApplicationController
  before_filter :authenticate_consumer!, :except => [:toggle_email_weekly, :login, :signup_form, :new, :create]
  skip_before_filter :require_no_authentication, :only => [:new, :create]
  before_filter :destroy_session, :only => [:login, :signup_form], :if => :consumer_signed_in?
  before_filter :set_app_session
  before_filter :has_location?, :except => [:edit, :update, :destroy_session], :if => :consumer_signed_in?



  layout :layout_by_resource 
  skip_before_filter :verify_authenticity_token
  skip_before_filter :has_location?, :only => [:destroy_session]

  def login
    render layout: "fullscreen"
  end

  def signup_form
    render layout: "fullscreen"
  end

  def has_location?
    if current_consumer && current_consumer.location.blank?
      session[:loc_error] = "Please enter your home zip code"
      redirect_to '/consumer/edit'
    elsif !session[:new_customer_path].nil?
      session[:new_customer_path] = nil
      redirect_to new_customer_path
    end
  end

  protected
    def destroy_session
      sign_out current_consumer
    end

    def set_app_session
      session[:app] ||= params[:app]
    end

    def layout_by_resource
      if consumer_signed_in?
        "consumers/application"
      else
        "consumers/public"
      end
    end

end