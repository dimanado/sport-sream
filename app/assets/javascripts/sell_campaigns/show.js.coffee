$ ->
  $('.sell .unlimited').click ->
    $('span.limit').hide()
    $('#campaign_coupon_attributes_amount').val('-1')
  $('.sell .limited').click ->
    $('span.limit').show()
    $('#campaign_coupon_attributes_amount').val('')
