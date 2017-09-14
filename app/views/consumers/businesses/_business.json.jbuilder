json.(business, :id, :name, :short_description, :full_address, :phone, :latitude, :longitude)
json.subscribed current_consumer.subscribed_to?(business)
json.distance business.distance_to(current_consumer).round(2)

if @messages.present?
  json.messages @messages.select {|m| m.business == business} do |json, message|
    json.partial! "consumers/dashboard/message", :message => message
  end
end
