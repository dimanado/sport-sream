class ContactUsController < ApplicationController

  layout :layout_by_request

  def new
    @message = ContactUsMessage.new
  end

  def create
    @message = ContactUsMessage.new(params[:contact_us_message])
    
    if @message.valid?
      HooddittMailer.contact_message(@message).deliver
      redirect_to(root_path, :notice => "Message was successfully sent.")
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end

  def layout_by_request
    if consumer_signed_in?
     "consumers/application"
    elsif merchant_signed_in? 
      "merchants"
    else 
      "pages"
    end
  end

end
