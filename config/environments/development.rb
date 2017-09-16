KD::Application.configure do
  config.cache_classes                          = false
  config.whiny_nils                             = true
  config.consider_all_requests_local            = true
  config.action_controller.perform_caching      = false
  config.active_support.deprecation             = :log
  config.action_dispatch.best_standards_support = :builtin
  config.assets.compress                        = false
  config.assets.debug                           = true
  config.assets.digest = false
  config.action_mailer.raise_delivery_errors    = true
  config.action_mailer.default_url_options      = { :host  => 'localhost:3000' }
  config.log_level = :debug
  ::ActiveSupport::Deprecation.silenced = true
  Rails.backtrace_cleaner.remove_silencers!

  ENV['ADMIN_CONTACT_EMAIL'] = 'support@dollarhood.com'
  ENV['ADMIN_CONTACT_EMAIL_MERCHANTS'] = 'business@dollarhood.com'
  ENV['FACEBOOK_CONSUMER_KEY'] = '1388457188133313'
  ENV['FACEBOOK_CONSUMER_SECRET'] = '178ce238e41ae64e792ade9aea4a9c58'


  # Generate digests for assets URLs
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "dollarhood.com",
    :user_name            => "mail@dollarhood.com",
    :password             => "hood$015gmail",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
  config.action_mailer.default_url_options = { :host => 'localhost' }

  config.after_initialize do

    #PayPal
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
      :login => "matt-facilitator_api1.hoodditt.com",
      :password => "1387964465",
      :signature => "An5ns1Kso7MWUdW4ErQKJJJ4qi4-Aoh491kR3f0zwwTKxECLKlaJnUQz"
    }
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)

  end

  #config.force_ssl = false


end
