class Consumers::RegistrationsController < Devise::RegistrationsController
  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :consumer && (action_name == 'new' or action_name == 'create')
#      is_mobile_request? ? "consumers/public" : "fullscreen"
       "fullscreen"
    else
      "consumers/application"
    end
  end

  def after_sign_up_path_for(consumer)
    '/'
  end

  def new
    @source = params[:source]
    @carousel = true
    super
  end

  def create
    @consumer = Consumer.new(params[:consumer])
    if params[:consumer][:referral_code]
      @consumer.referral = Referral.find_or_create_by_refkey(params[:consumer][:referral_code])
    end

    if params[:fancysignup]
      if @consumer.valid?
        #build_resource
        return create_success
      else
        return ajax_errors_for(@consumer)
      end
    else
      super
    end
  end

  def ajax_errors_for(consumer)
      render :json => {
        :success => false,
        :errors => consumer.errors
      }
  end

  def create_success
    @consumer.save
    #HooddittMailer.welcome_consumer(@consumer.email).deliver!
    sign_in(:consumer, @consumer)
    render :json => {
      :success => true,
      :redirect => after_sign_up_path_for(resource)
    }
  end

end
