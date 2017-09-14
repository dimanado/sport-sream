class CustomerController < ApplicationController
  before_filter :authenticate_consumer!
  layout :layout_by_request

  def new
    if current_consumer.location.blank?
      session[:loc_error] = "Please enter your home zip code"
      redirect_to '/consumer/edit'
      session[:new_customer_path] = new_customer_path
    else
      session[:new_customer_path] = nil
      fetch_new_transparent_redirect_data
    end

  end

  def edit
    fetch_edit_transparent_redirect_data
  end

  def confirm
    @result = Braintree::TransparentRedirect.confirm(request.query_string)

    if @result.success?
      current_consumer.braintree_customer_id = @result.customer.id
      current_consumer.save!
      # if session[:shopping_cart_id]
      #   @cart = shopping_cart
      #   redirect_to new_transaction_path(:number => params[:number]) and return
      # else
        #redirect_to(edit_customer_path(current_consumer), :notice => "Your profile was successfully updated.")
      redirect_to checkout_url
      # end
    elsif current_consumer.has_payment_info?
      fetch_edit_transparent_redirect_data
      render :action => "edit"
    else
      fetch_new_transparent_redirect_data
      render :action => "new"
    end
  end

  def layout_by_request
    consumer_signed_in? ? "consumers/application" : "merchants"
  end

  private
    def fetch_new_transparent_redirect_data
      @tr_data = Braintree::TransparentRedirect.
                  create_customer_data(:redirect_url => confirm_customer_url(:number => params[:number]))
    end

    def fetch_edit_transparent_redirect_data

      unless current_consumer.with_braintree_data!
        fetch_new_transparent_redirect_data
        return render :action => "new"
      end

      @credit_cards = current_consumer.credit_cards
      @tr_data = Braintree::TransparentRedirect.
                  update_customer_data(:redirect_url => confirm_customer_url,
                                       :customer_id => current_consumer.braintree_customer_id)
    end
end
