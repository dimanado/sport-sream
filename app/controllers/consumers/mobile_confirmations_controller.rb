class Consumers::MobileConfirmationsController < Consumers::ApplicationController

  skip_before_filter :authenticate_consumer!, :only => [:confirm]

  def confirm
    @confirmation_code = params[:confirmation_code]
    @consumer = Consumer.find_by_mobile_confirmation_token(@confirmation_code)
    if @consumer
       @consumer.mobile_confirmed_at = Time.now
       @consumer.mobile_confirmation_token = nil
       if @consumer.save
         flash[:success] = "Mobile number confirmed."
       else
         flash[:error] = @consumer.errors.full_messages.join
       end
    else
      flash[:error] = "Could not confirm mobile device: Invalid confirmation code."
    end
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else
      redirect_to edit_consumer_path
    end
  end

  def view
    current_consumer.deliver_mobile_confirmation_message
    redirect_to :back
  end
end
