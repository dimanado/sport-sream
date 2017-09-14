$ ->
  $("#coupon-creator")
    .find("input, textarea")
      .change ->
        $("#coupon-preview-frame").attr("src", "/coupons/preview?" + $(this.form).serialize())

  $("iframe#coupon-preview-frame").load ->
    $(this)
      .contents()
      .find("body")
      .css({
        #"zoom": "0.5"
      })
      .find("#content, #coupon")
        .css({'width': '320px'})