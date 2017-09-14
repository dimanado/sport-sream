class CreditCardInfoController < ApplicationController
  before_filter :authenticate_consumer!
  layout "consumers/application"
  respond_to :html, :js

  def new
    fetch_new_card_transparent_redirect_data
  end

  def edit
    @credit_card = Braintree::CreditCard.find(params[:id])
    fetch_edit_card_transparent_redirect_data
  end

  def destroy
    credit_card = Braintree::CreditCard.find(params[:id])
    if not credit_card.default?
      Braintree::CreditCard.delete(params[:id])
      redirect_to :back, :flash => {:success => "Successfully deleted"}
    else
      redirect_to :back, :flash => {:error => "Default card can't be deleted"}
    end
  end

  def set_default
    result = Braintree::CreditCard.update(
      params[:id],
      :options => {
        :make_default => true
      }
    )
    #todo: add result checking
    redirect_to :back
  end
  
=begin
  def edit_default

    if current_consumer && current_consumer.has_payment_info?
      unless current_consumer.with_braintree_data!
#        session['offer_id'] = params[:offer_id]
        redirect_to new_customer_path(:number => params[:number])
      end
      @credit_card = current_consumer.default_credit_card
      fetch_edit_card_transparent_redirect_data
      render :action => "edit"
    else
      redirect_to new_customer_path(:number => params[:number]) 
    end
  end
=end
  def confirm
    @result = Braintree::TransparentRedirect.confirm(request.query_string)

    if @result.success?
      redirect_to checkout_url
      #render :action => "confirm"
    else
      @credit_card = Braintree::CreditCard.find(@result.params[:payment_method_token])
      fetch_edit_card_transparent_redirect_data
      render :action => "edit"
    end
  end

  private
  def fetch_new_card_transparent_redirect_data
    @tr_data = Braintree::TransparentRedirect.
      update_customer_data(:redirect_url => confirm_credit_card_info_url,
                           :customer_id => current_consumer.braintree_customer_id)
      end

  def fetch_edit_card_transparent_redirect_data
    @tr_data = Braintree::TransparentRedirect.
      update_credit_card_data(:redirect_url => confirm_credit_card_info_url,
                              :payment_method_token => @credit_card.token)
      end

end
