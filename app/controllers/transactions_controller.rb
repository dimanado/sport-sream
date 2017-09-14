class TransactionsController < ApplicationController
  before_filter :authenticate_consumer!
  layout "consumers/application"

  def new
    partner = Partner.find_by_slug(cookies[:partner_slug]) || Partner.default_partner

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
        add_braintree_info
      end

      params[:number].each do |key, item|
        ShoppingCartItem.update(key.to_s, :quantity => item)
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
      render layout: 'application'
    else
      session['offer_id'] = params[:offer_id]
      redirect_to new_customer_path(:number => params[:number])
    end
  end

  def add_braintree_info
    session['offer_id'] = params[:offer_id]
    redirect_to new_customer_path(:number => params[:number])
  end

  def new_paypal
    summ = shopping_cart.shopping_cart_items.map(&:quantity).sum

    #generate options for PayPal
    options_arr = Array.new
    shopping_cart.shopping_cart_items.each do |offer|
       
      options_arr.push({
        :name => 'Dollarhood offer: ' +offer.item.subject,
        :quantity => offer.quantity,
        :description => offer.item.content,
        :amount => (offer.price*100).round
      });
    end

 
    response = EXPRESS_GATEWAY.setup_purchase((shopping_cart.total*100).round,
      :items => options_arr,
      :ip                => request.remote_ip,
      :return_url        => new_transaction_url,
      :cancel_return_url => root_url
    )

    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def confirm
    @cart = shopping_cart

    begin
      @result = Braintree::TransparentRedirect.confirm(request.query_string)
    rescue Braintree::NotFoundError => bang
      @cart = current_consumer.last_shopping_cart
      if @cart
        return render :confirm
      end
    end

    @transaction = shopping_cart.transactions.create do |t|
      t.status = @result.success? ? 'Success' : 'Failure'
      t.braintree_transaction_id = @result.transaction.id
      t.consumer_id = current_consumer.id
      t.amount = shopping_cart.total
    end

    if @result.success?
      shopping_cart.status = @result.transaction.status

      if (shopping_cart.status == 'authorized' || shopping_cart.status == 'submitted_for_settlement')
        plus_quantity
      end

      session[:shopping_cart_id] = nil
      HooddittMailer.consumer_cart_with_receipts(@cart, @transaction.confirmation_code).deliver
      render :confirm
    else
      current_consumer.with_braintree_data!
      @credit_card = current_consumer.default_credit_card
      render :new
    end
  end

  def confirm_paypal
    @cart = shopping_cart
    @transaction = @cart.transactions.last

    if @transaction.nil?
       @cart = current_consumer.last_shopping_cart
       return render :confirm
    end

    response = EXPRESS_GATEWAY.purchase( (@transaction.amount*100).round, express_purchase_options)

    @transaction.status = response.params["ack"]
    @transaction.paypal_transaction_id = response.authorization
    @cart.status = response.success? ? 'success' : 'fail'
    @transaction.save!

    if response.success?
      plus_quantity
      session[:shopping_cart_id] = nil
      HooddittMailer.consumer_cart_with_receipts(@cart).deliver
    end

    render :confirm
  end

  private

  def express_purchase_options
    summ = shopping_cart.shopping_cart_items.map(&:quantity).sum
    {
      :items => [{:name => 'Dollarhood transaction', :quantity => summ, :amount => 99}],
      :ip => request.remote_ip,
      :token => @cart.transactions.last.express_token,
      :payer_id => @cart.transactions.last.express_payer_id
    }
  end

  def plus_quantity
    shopping_cart.shopping_cart_items.each do |item|
      item.item.sold_count += item.quantity
      item.item.save!
    end
    shopping_cart.save!
  end

end
