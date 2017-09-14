$ ->
  id = qs 'reference'
  return unless id

  get_status = (id, cb)->
    return unless window.location.pathname.indexOf('buy_coupon') > 0
    $.getJSON "/consumer/coupon_purchase_status?id=#{id}", cb

  response_parser = (data)->
    if data.status is true
      console.log 'purchased'
      location.reload()
    else if data.status is false
      setTimeout ->
        get_status id, response_parser
      , 5000

  get_status id, response_parser