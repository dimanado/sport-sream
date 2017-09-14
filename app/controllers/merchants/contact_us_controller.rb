class Merchants::ContactUsController < Merchants::ApplicationController

  def new
    @message = ContactUsMessage.new
  end

  def create
    @message = ContactUsMessage.new(params[:contact_us_message])
    
    if @message.valid?
      HooddittMailer.contact_message(@message, true).deliver
      redirect_to(dashboard_path, :notice => "Message was successfully sent.")
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end

end
