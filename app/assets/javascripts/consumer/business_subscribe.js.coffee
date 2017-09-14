window.onbeforeunload = ()->
  if window._ajax
    return 'The background subscription is pending, please try it again in a few seconds.'

$ ->
  markAsSubscribed = ($business, changeState=true)->
    $business.attr('subscribed', 'true') if changeState
    $business.find('.status').removeClass('follow').html('Following')

  markAsUnsubscribed = ($business, changeState=true)->
    $business.attr('subscribed', 'false') if changeState
    $business.find('.status').addClass('follow').html('Follow')

  toggleSubscribe = ($business)->
    if $business.attr('subscribed') is 'true'
      markAsUnsubscribed($business)
    else
      markAsSubscribed($business)

  $('a.follow_this').click ()->
    self = this
    window._ajax = true
    $business = $(@).closest('[subscribed]')
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

  false