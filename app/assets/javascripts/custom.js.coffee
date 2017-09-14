window.clickAddToCart = () ->
  $("#qv-coupon").toggle()  
  $("body").css("overflow", "auto")

removeAllAttributes = (el) ->
  attributes = $.map(el.attributes, (item) ->
    if not (item.name is "style" or item.name is "class")
      return item.name)

  btn = $(el)
  $.each(attributes, (i, item) ->
    btn.removeAttr(item))

$ ->

  # dropdown
  $(".dropdown .dropdown-btn").on "click", ->
    $this = $(this)
    $this.next(".dropdown-list").toggle()
    false

  $(document).mouseup (e) ->
    el = $(".dropdown-list")
    el.hide()  if not el.is(e.target) and el.has(e.target).length is 0
    return

  # quick-view
  $(".qv-btn").on "click", ->
    $this = $(this)
    qvAttr = $this.attr("data-target")
    qvBox = $('#qv-coupon')
    request = $.ajax {
      url: "/coupons_json/" + qvAttr,
      type: "GET",
      dataType: "json",
      success: (data) ->

        $('.fb-link').attr('href', "http://api.addthis.com/oexchange/0.8/forward/facebook/offer?pco=tbx32nj-1.0&url=#{data.coupon.url}&pubid=ra-518ce20529de4a15")
        $('.twitter-link').attr('href', "http://api.addthis.com/oexchange/0.8/forward/twitter/offer?pco=tbx32nj-1.0&url=#{ data.coupon.url}&pubid=ra-518ce20529de4a15")
        $('.more-links').attr('href', "http://www.addthis.com/bookmark.php?source=tbx32nj-1.0&=300&pubid=ra-518ce20529de4a15&url=#{data.coupon.url}")

        $('.coupon-content').html(data.coupon.content)
        $('.coupon-subject').html(data.coupon.subject)
        if data.business.website != null
          $('.business-website').html("<a href=\"http://#{data.business.website}\">#{data.business.website}</a>")
        else
          $('.business-website').html ''


        if data.consumer_signed_in
          $(".btn-add-to-cart").each () ->

            removeAllAttributes(this)

            btn = $(this)
            btn.attr('href', "/shopping_cart/items?offer_id=#{data.coupon.id}")
            btn.attr('data-remote', 'true')
            btn.attr('data-method', 'post')
            btn.on('click', clickAddToCart)
            false

          $('.subscribe a').each () ->

            removeAllAttributes(this)

          btnSubscr = $('.subscribe a')
          if data.business.is_subscribed and data.business.subscribed
            btnSubscr.removeClass('follow')
            btnSubscr.html('Following')
          else
            btnSubscr.addClass('follow')
            btnSubscr.html('Follow')
            
          btnSubscr.attr('biz-id', data.business.id)

          qvBox.attr('is_subscribed', data.business.is_subscribed)
          qvBox.attr('subscribed', data.business.subscribed)

          false

        
        $('.business-name').html(data.business.name)
        unless data.business.online_business
          $('.business-address').html "#{data.business.address}</br>#{data.business.city}, #{data.business.state}, #{data.business.zip_code}</br>#{data.business.phone}"
        else
          $('.business-address').html("#{data.business.zip_code}</br>#{data.business.phone}")
        $('.expires-set').attr('data-expire', data.expires)

        if data.business.logo != ''
          $('.business-logo').html("<img src=\"#{data.business.logo}\">")
        else
          $('.business-logo').html('')

        if data.coupon.logo != ''
          $('.coupon-logo').html("<img src=\"#{data.coupon.logo}\">")
        else
          $('.coupon-logo').html('')

        # $('.qv-addthis').attr('addthis:url',  "https://www.dollarhood.com/coupons/#{data.coupon.code}")
        # $('.qv-addthis').attr('addthis:title', "#{data.business.name} - #{data.coupon.subject} - via @dollarhoodUS")
        # $('.qv-addthis').attr('addthis:description', data.coupon.content)
    }
    $("body").css("overflow", "hidden")
    qvBox.show()
    false

  $(".qv-close").on "click", ->
    $this = $(this)
    $("body").css("overflow", "auto")
    $this.closest(".quick-view").hide()
    false