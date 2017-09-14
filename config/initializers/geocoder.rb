Geocoder.configure(
  units: :mi,
  timeout: 15,
  ip_lookup: :telize
)

unless Rails.env.test?
  Geocoder::Configuration.lookup = :google
  #Geocoder::Configuration.lookup = :telize
end
