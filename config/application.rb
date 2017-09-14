require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "attachinary/orm/active_record"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Hooditt
  # Settings in config/environments/* take precedence over those specified here.
  class Application < Rails::Application
    # make ActiveAdmin use correct locale
    I18n.config.enforce_available_locales = true
    config.before_configuration do
      I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
      I18n.locale = :en
      I18n.default_locale = :en
      config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
      config.i18n.locale = :en
      # bypasses rails bug with i18n in production\
      I18n.reload!
      config.i18n.reload!
    end
    config.i18n.locale = :en
    config.i18n.default_locale = :en

    config.time_zone = 'Eastern Time (US & Canada)'
    config.encoding = "utf-8"
    config.default_locale = :en
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false
    config.assets.precompile += %w( .svg .eot .woff .ttf )
    config.assets.precompile += ['*.js', 'base.css', 'admin/application.css', 'admin/businesses.css', 'admin/consumers.css', 'admin/merchants.css', 'application.css', 'categories.css', 'coupons.css.css', 'global.css','hooditt.css' 'mobile/application.css', 'mobile/print.css', 'prettyPhoto.css', 'redesign/application.css', 'redesign/fullscreen.css', 'redesign/merchant_pick.css', 'redesign/picks.css', 'screen.css', 'sell_coupon/style.css', 'active_admin.css', 'hooditt_mailer.css', 'popup.css', 'landing.css', '3rd_party/jquery.hashtags.css', '3rd_party/jquery.multiselect.filter.css', '3rd_party/jquery.multiselect.css']
    config.assets.precompile += [/.*\/[^_]\w+\.(css|css.scss)$/]
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/app/util)
    config.autoload_paths += Dir["#{config.root}/app/models/*"].find_all { |f| File.stat(f).directory? }

    config.generators do |g|
      g.test_framework      :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    config.to_prepare do
      ActionMailer::Base.helper "application"
    end

    # use memcached as cache store
    #config.cache_store = :dalli_store
    config.cache_store = :dalli_store,
                    (ENV["MEMCACHIER_SERVERS"] || "").split(","),
                    {:username => ENV["MEMCACHIER_USERNAME"],
                     :password => ENV["MEMCACHIER_PASSWORD"],
                     :failover => true,
                     :socket_timeout => 1.5,
                     :socket_failure_delay => 0.2
                    }


    # log caching
    ActiveSupport::Cache::Store.logger = Rails.logger

    #SSL
    #config.force_ssl = true

  end
end
