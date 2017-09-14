class SendMaterialsJob
  @queue = :email
  def self.perform(partner_id, params, destinations)
    puts "SendMaterialsJob started for Partner##{partner_id}"
    partner = Partner.find_by_id(partner_id)
    if partner.nil?
      puts 'Partner not found! Stop'
      return
    end
    begin
      email_data = { subject:   params['material_subject'],
                     body:      params['material_body'],
                     materials: params['materials'] }
      destinations.each do |destination_email|
        puts 'Started for destination: ' + destination_email
        package = HooddittMailer.send_marketing_material(partner, email_data, destination_email)
        puts 'Created package for ' + destination_email
        package.deliver
      end
      puts 'All Emails Sended! exit.'
    rescue Exception => e
      puts e.inspect
    end
  end
end
