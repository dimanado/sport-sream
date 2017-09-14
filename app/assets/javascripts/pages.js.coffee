$ ->
  $("li[rel=toolset-rollover]").hover (e) ->
    title = $(this).text()
    $("p.target strong").text(title)

    content = $(this).attr("data-content")
    $("p.target span.content").text(content)

    icon = $(this).attr("data-icon-name")
    $("p.target img").attr("src", image_path(icon))

  $(".util_bus_login a").click ->
    $("#user-bar").animate({left: -1000}, 200)
  $(".util_consumer_login a").click ->
    $("#user-bar").animate({left: 148}, 200)

  $('#business_online_business').change ->
    $('.promocode_field').toggle()