ActiveAdmin.register_page "Dump Consumers" do

  ##
  # Menu
  menu parent: "Info", priority: 92

  content do
    form action: admin_dump_consumers_dump_path do
      span "Click to send yourself (#{current_partner.email}) an email containing CSV dump of consumers who purchased an offer (last 2 weeks)."
      br
      input type: :submit
    end
  end

  page_action :dump, method: :get do
    email = current_partner.email

    start_date = DateTime.now.at_beginning_of_week
    end_date = DateTime.now

    if current_partner.role != "admin"
       partner = current_partner
       redirect_to admin_dump_consumers_path, notice: "This feature is available for Admins only"
       return
    end

    filtered_transactions = Transaction.where(:created_at => start_date..end_date)
    consumer_emails = []

    filtered_transactions.each do |cur_trans|
     if cur_trans.consumer.present?
       consumer = cur_trans.consumer
       consumer_emails << cur_trans.consumer.email
     end

    end

    consumer_emails = consumer_emails.uniq
  
    consumers_CSV = CSV.generate do |csv|
      csv << ["eMail"]
      consumer_emails.each do |email|
        row = [email]     
        csv << row
      end
    end
    

    the_mail = AdminMailer.csv_dump(email, {
      "consumers.csv" => consumers_CSV
    })
    the_mail.deliver
    
    redirect_to admin_dump_consumers_path, notice: "Data was sent to #{email}"
  end


end 
