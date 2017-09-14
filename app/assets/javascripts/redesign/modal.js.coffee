$.fn.viewportOffset = ->
  offset = $(@).offset()
  win = $(window)
  {
    left: offset.left - win.scrollLeft()
    top: offset.top - win.scrollTop()
  }


forceScroll = ($modal)->
  forceWindowScrollY = -1

  $(window).scroll (event)->
    if forceWindowScrollY != -1 && window.scrollY != forceWindowScrollY
      $(window).scrollTop(forceWindowScrollY)   
  
  $($modal).hover ->
    if(forceWindowScrollY == -1)
      forceWindowScrollY = $(window).scrollTop()
  , ->
    forceWindowScrollY = -1


wrap = ($modal)->
  $modal.show()
  $parent = $modal.parent()
  if $parent.hasClass 'modalbg'
    return $parent
  else
    return $modal.wrap('<div class="modalbg"></div>').parent()


getTopOffset = ($target)->
  elemOffset = $target.offset()
  viewOffset = $target.viewportOffset()
  return elemOffset.top - viewOffset.top


$ ->
  $('*[data-modal]').each (i,e)->
    id = $(@).attr('data-modal')
    $modal = $(".modal##{id}")
    forceScroll($modal)
    $wrap = wrap($modal)
    $modal.click (e)-> e.stopPropagation()
    $(e).prop('modal-trigger', true)

    $(e).click (event)->
      if $(e).attr('data-modal')
        $('.modalbg').hide() # hide other modals
        $wrap.css('top', getTopOffset($(@))).fadeIn(500)
        $modal.find('.body').css('max-height', $(window).height()-200)
        $modal.find('#consumer_email').focus()
        params = $(@).attr 'data-mparams'
        if params then $modal.attr 'params', params
        $('body').trigger 'modalshow'
        event.stopPropagation()
        false

  $('html').one().click (event)->
    return if $(@).prop('modal-trigger')
    $('body').trigger 'modalhide'
    $('.modalbg .modal')
      .removeAttr('params')
      .parent()
      .fadeOut(500)
