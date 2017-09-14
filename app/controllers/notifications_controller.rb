class NotificationsController < ApplicationController
  def create
    @partner = current_partner
    fail = false

    if params[:recipient_ids].present? && params[:subject].present? && params[:body].present?

      params[:recipient_ids].each do |recipient_id|
        # create notification sent by current partner
        notification = Notification.create!(:subject => params[:subject], :body => params[:body],
                                            :recipient_id => Partner.find(recipient_id.to_i).id,
                                            :sender_id => current_partner.id)

      end
      flash[:notice] = "Tested successfully!"
    else
      flash[:error] = "Please make sure all params are filled"
    end

    redirect_to admin_notifications_path
  end
end
