module CampaignsHelper
  require 'nokogiri'

  def cost_formatter(decimal_cost)
    number_to_currency(decimal_cost)
  end

  def terms_check_box(terms_string, form_builder)
    object = form_builder.object
    html = form_builder.check_box(:terms, {:multiple => true, :checked => object.terms.include?(terms_string)}, terms_string, nil)
    doc = Nokogiri::HTML html
    html << content_tag(:label, terms_string, {:for => doc.css('input')[0]['id']})
  end

  def campaign_icon(campaign)
      image_tag "coupon_icon.png", :size => "32x32"
  end
end
