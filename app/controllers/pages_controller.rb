class PagesController < ApplicationController
  def index
  #  if is_mobile_request?
  #    if consumer_signed_in?
  #      redirect_to consumers_dashboard_path
  #    else
  #      redirect_to new_consumer_session_path
  #    end
  #  end
  end

  def dollarhood_for_business
    session['partner'] = defined?(params[:partner_slug]) && params[:partner_slug]
    render 'hooditt-for-business'
  end
end
