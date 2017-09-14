class HooddittMailer < ActionMailer::Base
  default from: "Dollarhood <customer@dollarhood.com>"
  default content_type: "text/html"
  layout 'hoodditt_mail'

  add_template_helper(ApplicationHelper)

  def consumer_import_report(email, collection)
    @all = collection
    @valid = @all.select {|c| c.valid? }
    @invalid = @all.select {|c| c.errors.any? }
    attachments.inline['left.jpg'] = File.read(Rails.root.join("app","assets", "images", "dollarhood", "dollarhood-logo-smaller.jpg"))

    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: email,
          subject: 'Import consumers report') do |format|
      format.html
    end
  end

  def consumer_confirmation (email)
    @token = Digest::SHA1.hexdigest(email)
    attachments.inline['left.jpg'] = File.read(Rails.root.join("app","assets", "images", "dollarhood", "dollarhood-logo-smaller.jpg"))

    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: email,
          subject: "Please confirm your new email") do |format|
      format.html
    end
  end

  def contact_message(message, send_to_admin_merchants = false)
    @message = message
    attachments.inline['left.jpg'] = File.read(Rails.root.join("app","assets", "images", "dollarhood", "dollarhood-logo-smaller.jpg"))

    @send_to = send_to_admin_merchants ? ENV['ADMIN_CONTACT_EMAIL_MERCHANTS'] : ENV['ADMIN_CONTACT_EMAIL']

    mail( from: "Dollarhood <customer@dollarhood.com>",
          subject: "[Dollarhood] #{message.subject}",
          to: @send_to)
  end

  def consumer_coupon_code (code)
    @coupon_code = code
    @coupon = code.coupon
    @business = @coupon.business
    @expires = @coupon.campaign.expires_at
    email = code.consumer.email
    attachments.inline['left.jpg'] = File.read(Rails.root.join("app","assets", "images", "dollarhood", "dollarhood-logo-smaller.jpg"))

    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: email,
          subject: "You successfully bought a coupon") do |format|
      format.html
    end
  end

  def consumer_coupon_codes(codes)
    @codes = codes
    email = codes.first.consumer.email
    attachments.inline['left.jpg'] = File.read(Rails.root.join("app","assets", "images", "dollarhood", "dollarhood-logo-smaller.jpg"))

    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: email,
          subject: "You successfully bought a coupon")
  end

  def consumer_receipt_with_pass(order)

    @order = order
    @coupon = order.offer
    @business = @coupon.business
    @expires = @coupon.campaign.expires_at
    email = order.consumer.email
    attachments.inline['left.jpg'] = File.read(Rails.root.join("app","assets", "images", "dollarhood", "dollarhood-logo-smaller.jpg"))
    attachments['coupon_email.pdf'] = WickedPdf.new.pdf_from_string(
          render_to_string(:pdf => 'coupon_email',:template => '/hoodditt_mailer/consumer_receipt_with_pass.pdf.haml')
        )

    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: email,
          subject: "Dollarhood - You successfully purchased an offer") do |format|
      format.html
    end
  end

  def consumer_cart_with_receipts(cart, trans_confirm_code)
    @cart = cart
    @trans_confirm_code = trans_confirm_code
    email = @cart.consumer.email
    attachments.inline['logo-smaller.jpg'] = File.read(Rails.root.join("app","assets", "images", "dollarhood/dollarhood-logo-smaller.jpg"))
    attachments.inline['logo.jpg'] = File.read(Rails.root.join("app","assets", "images", "logo.jpg"))

    @cart.shopping_cart_items.each_with_index do |cart_item, index|
      file_number = (index+1).to_s
      file_name = 'coupon'+ file_number + '.pdf'
      attachments[file_name] = WickedPdf.new.pdf_from_string(
        render_to_string(:pdf => 'coupon_email', :template => '/hoodditt_mailer/consumer_cart_with_receipts.pdf.haml', :locals => {:cart_item => cart_item})
      )
    end

    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: email,
          subject: "Dollarhood - You successfully purchased an offer") do |format|
      format.html { render layout: false }
    end

  end

  def send_marketing_material(partner, email_data)
    attachments.inline['logo.jpg'] = File.read(Rails.root.join("app","assets", "images", "logo.jpg"))
    attachments.inline['icon_facebook.jpg'] = File.read(Rails.root.join("app","assets", "images", "icon_facebook.jpg"))
    attachments.inline['icon_twitter.jpg'] = File.read(Rails.root.join("app","assets", "images", "icon_twiter.jpg"))
    @partner = partner
    materials = email_data[:materials]
    send_from_email = @partner.email
    send_to_email = email_data[:material_email]
    @body = email_data[:body]
    materials.each do |material_id|
      material = Material.find(material_id)
      if material.file.resource_type == "raw"
        names = material.file.path.split('.')
        format = names[1].nil? ? '' : '.' + names[1]
        file_name = material.title.sub(' ', '_').downcase + format
        attachments.inline[file_name] = Net::HTTP.get(URI(material.full_path))
      else
        file_name = material.title.sub(' ', '_').downcase + '.' + material.file.format
        attachments.inline[file_name] = Net::HTTP.get(URI(material.full_path))
      end
    end
    mail( from: send_from_email,
          to: send_to_email,
          subject: 'Dollarhood - Welcome business!') do |format|
      format.html  { render layout: 'email_layout' }
    end

  end

  def message_coupon(message, consumer)
    @consumer = consumer
    @campaign = message.campaign
    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: @consumer.email,
          subject: @campaign.coupon.subject,
          body: message.content)
  end

  # this is a new HTML message type
  def subscriber_new_coupon(message, consumer)
    @consumer = consumer
    @campaign = message.campaign
    @coupon = message.campaign.coupon
    attachments.inline['left.jpg'] = File.read(Rails.root.join("app","assets", "images", "dollarhood", "dollarhood-logo-smaller.jpg"))
    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: @consumer.email,
          subject: @campaign.coupon.subject
        )
  end

  #a bulletin is a message with no coupon attached
  def message_bulletin(message, consumer)
    @consumer = consumer
    @campaign = message.campaign
    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: @consumer.email,
          subject: message.content,
          body: message.content)
  end

  def consumer_weekly (email)
    @consumer = Consumer.where(email: email).first
    @local_businesses = Business.near(@consumer.location, 100)
    @coupons = @consumer.messages.redeemable + @consumer.interesting_indirect_messages
    @new_businesses = Business.where('created_at > DATE(?)', 1.week.ago.to_date)

    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: email,
          subject: "Dollarhood Summary")
  end

  def welcome_consumer (email)
    attachments.inline['logo.jpg'] = File.read(Rails.root.join("app","assets", "images", "logo.jpg"))
    attachments.inline['icon_facebook.jpg'] = File.read(Rails.root.join("app","assets", "images", "icon_facebook.jpg"))
    attachments.inline['icon_twitter.jpg'] = File.read(Rails.root.join("app","assets", "images", "icon_twiter.jpg"))

    # attachments.inline['hoodditt_wemail.jpg'] = File.read(Rails.root.join("app","assets", "images", "hoodditt_wemail.jpg"))
    @email = email
    mail( from: "Dollarhood <customer@dollarhood.com>",
          to: email,
          subject: "Welcome to the neighborhood!") do |format|
      format.text
      format.html { render layout: 'email_layout' }
    end
  end

  def welcome_merchant (email)
    attachments.inline['logo.jpg'] = File.read(Rails.root.join("app","assets", "images", "logo.jpg"))
    attachments.inline['icon_facebook.jpg'] = File.read(Rails.root.join("app","assets", "images", "icon_facebook.jpg"))
    attachments.inline['icon_twitter.jpg'] = File.read(Rails.root.join("app","assets", "images", "icon_twiter.jpg"))
    mail( from: "Dollarhood <business@dollarhood.com>",
          to: email,
          subject: "Welcome to the neighborhood!") do |format|
      format.text
      format.html { render layout: 'email_layout' }
    end
  end

  def welcome_partner (email, reset_password_token)
    @email = email
    @reset_password_url = edit_partner_password_url(reset_password_token: reset_password_token)
    attachments.inline['left.jpg'] = File.read(Rails.root.join("app","assets", "images", "dollarhood", "dollarhood-logo-smaller.jpg"))
    mail( from: "Dollarhood <partner@dollarhood.com>",
          to: @email,
          subject: "Dollarhood - Thank you for joining us!") do |format|
      format.text
      format.html { render layout: 'cunsumer_mail' }
    end
  end

end
