class DispatchesController < ApplicationController
  def create
    @partner = current_partner
    fail = false

    if params[:materials].present? && params[:material_email].present?

      # create dispatch with specific materials for current partner
      dispatch = Dispatch.new(:partner_id => current_partner.id)
      dispatch.materials = Material.find_all_by_id(params[:materials])
      unless dispatch.save
        fail = true
      end

      emails = params[:material_email].split(',').map(&:strip).uniq
      if (emails.all? { | email | (email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i) == 0 } )
        if fail
          flash[:error] = "Dispatch failed..."
        else
          flash[:notice] = "Dispatched successfully!"
          Resque.enqueue(SendMaterialsJob, @partner.id, params, emails)
          HooddittMailer.send_marketing_material(@partner, params).deliver

          emails.each do |email|
            # create DispatchRecepient for each email with 'sent' status
            DispatchRecipient.create(:dispatch_id => dispatch.id, :status => "sent", :email => email)
          end
        end
      else
        flash[:error] = "Enter a valid email"
      end
    else
      flash[:error] = "Some materials should be selected and the email field should be filled"
    end

    redirect_to admin_materials_path
  end
end
