window.onbeforeunload = ()->
  if window._ajax
    return 'The background subscription is pending, please try it again in a few seconds.'

$ ->
  markAsSubscribed = ($business, changeState=true)->
    $business.attr('data-subscribed', 'true') if changeState
    $business.find('a.pick_this').removeClass('pick_this_half_grey')
    $business.find('.new_offer').removeClass('grey_border')
    $business.find('.green_bottom').removeClass('grey_color')
    $business.find('.status').removeClass('follow').addClass('following').html('Following')

  markAsUnsubscribed = ($business, changeState=true)->
    $business.attr('data-subscribed', 'false') if changeState
    $business.find('a.pick_this').addClass('pick_this_half_grey')
    $business.find('.new_offer').addClass('grey_border')
    $business.find('.green_bottom').addClass('grey_color')
    $business.find('.status').removeClass('following').addClass('follow').html('Follow')

  $('*[data-subscribed]').each (i,e)->
    $e = $(e)
    console.log $e
    if $e.attr('data-subscribed') is 'true'
      markAsSubscribed($e, false)
    else
      markAsUnsubscribed($e, false)

  toggleSubscribe = ($business)->
    if $business.attr('data-subscribed') is 'true'
      markAsUnsubscribed($business)
    else
      markAsSubscribed($business)

  $('a.pick_this').click ()->
    self = this
    window._ajax = true
    $business = $(@).parent()
    toggleSubscribe($business)

    $.ajax {
      type: 'POST'
      url: '/consumers/businesses/' + $(self).attr('biz-id') + '/toggle_subscription'

      success: ()->
        window._ajax = false
        
      error: ()->
        alert 'There was a error subscribing to this business, please contact the site admin'
        window._ajax = false
        toggleSubscribe($business)
    }

  $('a.follow_this').click ()->
    self = this
    window._ajax = true
    $business = $(@).parent().parent().parent()
    toggleSubscribe($business)

    $.ajax {
      type: 'POST'
      url: '/consumers/businesses/' + $(self).attr('biz-id') + '/toggle_subscription'

      success: ()->
        window._ajax = false
        
      error: ()->
        alert 'There was a error subscribing to this business, please contact the site admin'
        window._ajax = false
        toggleSubscribe($business)
    }

  $('*[data-subscribe]').each (i,link)->
    $link = $(link)
    return unless $link.attr('data-subscribe')

    $link.click (event)->
      event.preventDefault()
      return if $link.hasClass('subscribed')
      $link.text 'Subscribing...'
      $.ajax {
        type: 'POST'
        url: '/consumers/businesses/' + $(this).attr('data-subscribe') + '/toggle_subscription'
        success: ->
          $link.addClass('buybtn')
          $link.text 'Buy'
          $link.removeAttr('data-subscribe')
        error: ->
          console.error 'ploho delo'
      }
