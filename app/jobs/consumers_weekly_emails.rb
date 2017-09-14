class WeeklyConsumerEmail
  
  def self.perform
    Consumer.all.each do |c|
      begin
        c.send_weekly_email
      rescue Exception => e
	    p e
      end
    end
  end

end