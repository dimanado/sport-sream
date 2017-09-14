class DollarhoodDeviseMailer < Devise::Mailer   
  default from: "Dollarhood <support@dollarhood.com>"
  default content_type: "text/html"
  layout 'email_layout' 

  def reset_password_instructions(record, token, opts={})

    attachments.inline['logo.jpg'] = File.read(Rails.root.join("app","assets", "images", "logo.jpg"))
    attachments.inline['icon_facebook.jpg'] = File.read(Rails.root.join("app","assets", "images", "icon_facebook.jpg"))
    attachments.inline['icon_twitter.jpg'] = File.read(Rails.root.join("app","assets", "images", "icon_twiter.jpg"))

      super
  end

end
