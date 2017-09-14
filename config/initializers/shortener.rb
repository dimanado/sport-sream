require 'shortener'

#server running the guillotine app
Shortener.url = "http://chki.us"
Shortener.url = "http://localhost:3000/coupons" if Rails.env.development?
if Rails.env.development? || Rails.env.test?
  Shortener.stubbed = true
end
