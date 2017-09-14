class AdminMailer < ActionMailer::Base

  def csv_dump(to, csv_contents)
    csv_contents.each do |name, contents|
      attachments[name] = {
        mime_type: 'text/csv',
        content: contents
      }
    end
    mail(
      from: "Dollarhood <customer@dollarhood.com>",
      to: to,
      subject: "CSV dump from #{Time.zone.now} (#{Time.zone.name})"
    ) do |format|
      format.text {render :text => "CSV Dump"}
    end
  end
 
end 
