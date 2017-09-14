class CheckoutController < ApplicationController
  before_filter :authenticate_consumer!

  def cr_card_confirm

    if request.query_string.present?
      @result = Braintree::TransparentRedirect.confirm(request.query_string)
    
      if @result.success?
        render :action => "cr_card_confirm"
      else  
        @credit_card = Braintree::CreditCard.find(@result.params[:payment_method_token])
        @submit_payment_disabled = true
        render :action => "cr_card_confirm_failure"
      end
    end

  end


  def checkout

    partner = Partner.find_by_slug(cookies[:partner_slug]) || Partner.default_partner

    generate_entries(current_consumer.all_offers)
    @offers = Consumer.near(current_consumer.location, 100000, @offers)
    @offers = @offers.first(4)

    if params[:token]
      @transaction = shopping_cart.transactions.create! do |t|
        t.consumer_id = current_consumer.id
        t.amount = shopping_cart.total
        t.express_token = params[:token]
      end

      shopping_cart.consumer_id = current_consumer.id
      shopping_cart.partner_id = partner.id
      shopping_cart.save!

    elsif current_consumer.has_payment_info?
      unless current_consumer.with_braintree_data!
        session['offer_id'] = params[:offer_id]
        redirect_to new_customer_path(:number => params[:number])
      end

      unless params[:number].blank?
        params[:number].each do |key, item|
          ShoppingCartItem.update(key.to_s, :quantity => item)
        end
      end

      shopping_cart.consumer_id = current_consumer.id
      shopping_cart.partner_id = partner.id
      shopping_cart.save!

      @credit_card = current_consumer.default_credit_card

      @tr_data = Braintree::TransparentRedirect.transaction_data(redirect_url: confirm_transaction_url,
                                                                  transaction: {
                                                                    amount: shopping_cart.total,
                                                                    customer_id: current_consumer.braintree_customer_id,
                                                                    :options => {
                                                                      :submit_for_settlement => true
                                                                    },
                                                                    type: "sale"
                                                                  }
                                                                )
      @tr_cc_data = Braintree::TransparentRedirect.
                  update_credit_card_data(:redirect_url => cr_card_confirm_url,
                                          :payment_method_token => @credit_card.token)


    else
      session['offer_id'] = params[:offer_id]
      redirect_to new_customer_path(:number => params[:number])
    end
  end


  def set_tr
    @tr_data = Braintree::TransparentRedirect.transaction_data(redirect_url: confirm_transaction_url,
                                                                transaction: {
                                                                  amount: shopping_cart.total,
                                                                  customer_id: current_consumer.braintree_customer_id,
                                                                  :options => {
                                                                    :submit_for_settlement => true
                                                                  },
                                                                  type: "sale"
                                                                }
                                                              )
    respond_to :js
  end
end
