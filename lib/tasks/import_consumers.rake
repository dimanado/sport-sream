namespace :csv do
  desc "imports a CSV of the old chinoki database. Only Consumers"
  task :import_consumers => :environment do
    file  = ENV["CSV"]
    puts "disabling mobile confirmation callback"
    Consumer.destroy_all
    Consumer.skip_callback(:save, :before, :reset_mobile_confirmation)

    CSV.foreach(file, :headers => :first_row) do |row|
      consumer = Consumer.new do |c|
        c.name = row['email']
        c.email = row['email']
        c.birth_year = row['birth_year']
        c.created_at = Time.zone.parse(row['created'])
        c.updated_at = Time.zone.parse(row['modified'])
        #enabled
        c.mobile = row['mobile']
        #carrier
        c.gender = row['gender'].downcase
        #optin
        c.encrypted_password = row['password']
        c.location = row['zip_code']
        #c.latitude = row['latitude']
        #c.longitude = row['longitude']
        c.mobile_confirmation_sent_at = Time.zone.parse(row['created'])
        c.mobile_confirmed_at = Time.zone.now
        c.message_delivery_preference = 'DeliveryChannel::Sms'
      end
      consumer.geocode
      consumer.save(:validate => false)
      puts "imported - #{consumer.id} - #{consumer.email}"
    end
  end
end
