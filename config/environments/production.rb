KD::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.css_compressor = :yui
  config.assets.js_compressor = :uglifier

  # config.assets.prefix = "/production/assets"

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = File.join(Rails.public_path, config.assets.prefix)

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( hooditt.css )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Check if on test environment and set the proper URL for mailer


  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'
  }
  config.action_mailer.default_url_options = { :host => 'dollarhood.com' }

  config.action_controller.asset_host =  "//#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com"
  config.action_mailer.asset_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com"

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  ENV['ADMIN_CONTACT_EMAIL'] = 'support@dollarhood.com'
  ENV['ADMIN_CONTACT_EMAIL_MERCHANTS'] = 'business@dollarhood.com'
  ENV['FACEBOOK_CONSUMER_KEY'] = '1382213805358825'
  ENV['FACEBOOK_CONSUMER_SECRET'] = 'c90b6cece02e77ed636357597cc705bf'

  config.after_initialize do

    #PayPal
    ActiveMerchant::Billing::Base.mode = :production
    paypal_options = {
      :login => "matt_api1.hoodditt.com",
      :password => "MY9T8M7XJ8GNHVGV",
      :signature => "AaZyTP-Csjc431QXe9QJ8r7XGxnWACsC1jlHSeZ1YuGUDPEQFJJfRbOp"
    }
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)

  end
end
