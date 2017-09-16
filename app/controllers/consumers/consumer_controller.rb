class Consumers::ConsumerController < Consumers::ApplicationController
  before_filter :load_consumer
 # add_breadcrumb "Profile", :edit_consumer_path

  def index
    redirect_to consumers_dashboard_path
  end

  def show
    respond_to do |format|
      format.html { redirect_to edit_consumer_path }
      format.mobile { redirect_to edit_consumer_path }
      format.json { render :json => current_consumer }
    end
  end

  def coupon_purchase_status
    #checks if the consumer has bought a coupon
    coupon = Coupon.find_by_id(params[:id])

    render json: {:status => nil}
  end

  def edit
    #params[:show_mobile_confirmation] = true
  end

  def confirm_email
    if params[:resend]
      current_consumer.send_confirmation_email
      redirect_to edit_consumer_path
      return
    end

    if params[:token] == current_consumer.confirmation_token
      unless current_consumer.email_confirmed?
        if current_consumer.update_attribute(:email_confirmed, true)
          flash[:success] = 'The email was confirmed successfully.'
        else
          flash[:error] = 'There was a error confirming your email'
        end
      else
        flash[:success] = 'You already confirmed your email.'
      end
    else
      flash[:error] = 'Invalid confirmation token.'
    end
  end

  def update
    if (params[:consumer][:password].blank? rescue false)
      params[:consumer].delete :password
      params[:consumer].delete :password_confirmation
    end

    if params[:ucat] and params[:consumer].nil?
      params[:consumer] = {:category_ids => []}
    end

    if @consumer.update_attributes(params[:consumer])
      flash[:success] = 'Profile was successfully saved.'
      respond_to do |format|
        format.html { params[:ucat] ? redirect_to(consumers_categories_path) : redirect_to(edit_consumer_path) }
        format.json { render :json => @consumer.reload }
        format.mobile { params[:ucat] ? redirect_to(consumers_categories_path) : redirect_to(edit_consumer_path) }
      end
    else
      respond_to do |format|
        format.html {render :edit, :status => 422}
        format.json {render :json => @consumer.reload, :status => 422}
        format.mobile { render :edit, :status => 422 }
      end
    end
  end

  def toggle_email_weekly
    user = Consumer.find_by_id(params[:u])
    unless user.nil?
      @valid_token = user.confirmation_token == params[:h]
    else
      @valid_token = false
    end

    @unsubscribed = !user.weekly_digest? if @valid_token

    if request.post?
      if user.unsubscribe_from_weekly_digest
        @unsubscribed = true
        flash[:success] = 'You unsubscribed from weekly emails.'
      else
        flash[:error] = 'There was a problem unsubscribing you.'
      end
    end
  end
  

  def buy_coupon
    if current_consumer.account.nil?
      session[:consumer_billing_redir] = params[:reference]
      redirect_to ConsumerAccount.chargify_signup_link_for(current_consumer)
    else
      @coupon = Coupon.find(params[:reference])
      @coupon_codes = current_consumer.coupon_codes.where(:coupon_id => @coupon.id) rescue []
      @pending_purchase = current_consumer.account.pending_purchase?(@coupon) || session[:recheck]
      session.delete(:recheck)

      @business = @coupon.campaign.business
      @business.subscribers << current_consumer unless current_consumer.subscribed_to?(@business)

      return emit_purchase if request.post?
    end
  end

  def emit_purchase
    quantity = params[:quantity] || 1
    status, error = EmitsCouponPurchase.emit(current_consumer.account, @coupon, quantity)
    if true == status
      flash[:success] = 'The charge was successfully emitted, you will receive the email with the coupon shortly.'
    else
      flash[:error] = error
    end

    respond_to do |format|
      format.json { render :json => {:success => status, :error => error} }
      format.html { render 'buy_coupon' }
      format.mobile { render 'buy_coupon' }
    end
  end

  def update_location
    unless params[:lat] && params[:lng]
      return head(:bad_request)
    end

    @consumer.location = nil
    @consumer.latitude = params[:lat]
    @consumer.longitude = params[:lng]
    @consumer.save
    session[:updated_location_at] = @consumer.updated_at
    render :json => @consumer.reload
  end

  private
    def load_consumer
      @consumer = current_consumer
    end
end
