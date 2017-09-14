$ ->
  return if $(".profile_content_btn a").length == 0
  $(".profile_content_btn a")
    .click ->
      $(this).parents("form").submit()
      false
    .position
      my: "bottom",
      at: "top",
      of: ".profile_content"
    .css "z-index", 100
