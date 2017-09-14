module RedemptionHelper
  def message_status_notification(message)
    return if message.nil?
    valid = message.errors.empty?
    block_message = content_tag(:div,
      message_status_title(message) + message_status_explanation(message),
      :class => 'alert-message block-message ' + (valid ? 'success' : 'error'))
  end

  def message_status_explanation(message)
    if message.errors.empty?
      explanation = content_tag(:p, h(message.campaign.message_content))
    else
      explanation = content_tag(:ul, message.errors.full_messages.map do |message|
        content_tag(:li, message)
      end.join.html_safe)
    end
  end

  def message_status_title(message)
    if message.errors.empty?
      content_tag(:strong, "The code was valid for:")
    else
      content_tag(:strong, "The code is not redeemable")
    end
  end
end
