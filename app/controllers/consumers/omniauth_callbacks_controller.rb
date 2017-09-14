class Consumers::OmniauthCallbacksController < Devise::OmniauthCallbacksController
   def facebook
    @consumer = Consumer.find_for_facebook_oauth(request.env["omniauth.auth"])
    if @consumer.persisted?
      sign_in_and_redirect @consumer, :event => :authentication
    end
  end
end