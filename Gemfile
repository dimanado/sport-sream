if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source 'http://rubygems.org'
ruby "2.0.0"

gem 'mysql2'

gem 'rails', '3.2.16'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'haml'

gem 'devise', '3.2.2'
gem 'devise-encryptable'
gem 'dynamic_form'

gem 'activeadmin', :git => 'https://github.com/gregbell/active_admin.git'
gem 'cancan'

gem "redis", '3.0.7'
gem "resque", github: "resque/resque", branch: "1-x-stable"
gem 'resque-scheduler', '2.5.5'

gem 'state_machine'
gem 'active_admin-state_machine'

gem 'geocoder', '~> 1.2.6'

gem 'braintree'
gem 'roadie'
#gem "mail_view"
gem 'wkhtmltopdf-binary'
gem 'wicked_pdf'

gem 'meta-tags-helpers'

gem 'unf'
gem 'aws-sdk'
gem 'carmen-rails'
gem 'json'

gem 'oauth'
gem "twitter"
gem 'twitter_oauth'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'fb_graph'

gem 'koala'
gem 'activemerchant'

gem 'airbrake', '3.1.16'
gem 'newrelic_rpm'

gem 'httparty'
gem 'rest-client', :require => 'rest-client'

gem 'acts_as_tree'
gem 'mobylette'
gem 'breadcrumbs_on_rails'
gem 'kaminari'
gem 'rabl'
gem 'oj'
gem 'jbuilder'
gem 'attachinary'
gem 'cloudinary'
gem 'acts_as_shopping_cart', :github => 'crowdint/acts_as_shopping_cart', :branch => '0-1-x'
gem 'yui-compressor'
gem 'coffee-rails' # used to render ajax response views and is required in production

gem 'httpclient'

# optimization
gem 'multi_fetch_fragments'
gem 'dalli'
gem 'memcachier'
gem 'cache_digests'

# layout nesting gem
gem 'nestive', '~> 0.5'

group :development do
  gem 'foreman', require: false
  gem 'heroku', require: false
  gem 'pry-rails'
  gem 'pry-doc', require: false
  gem 'pry-byebug'
  gem 'xray-rails'
end

group :test do
  gem 'turn', :require => false
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy'
  gem 'resque_spec'
  gem 'timecop'
  # gem 'mocha', require: false
  gem 'faker'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'json_spec'
  gem 'fakeweb'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
end

group :development, :test do
  gem 'quiet_assets'
  gem 'rspec-rails'
  gem 'guard-livereload'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'
end

group :production do
  gem 'unicorn'
  gem 'bounscale'
  gem 'rails_12factor'
end

group :assets do
  gem 'asset_sync'
  gem 'sass-rails'
  gem 'uglifier'
  gem 'turbo-sprockets-rails3'
end

group :development do
  gem 'execjs'
  gem 'therubyracer'
  gem 'meta_request'
end
