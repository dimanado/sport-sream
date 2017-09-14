$ ->
  $('.attachinary-input').addClass('hidden')
  $('a.click-to-browse').click ->
    $('.attachinary-input').attachinary()
    $('.attachinary-input').removeClass('hidden').click()
    $('.attachinary_container ul').addClass('hidden')
    $('.attachinary-input').addClass('hidden')
  $(".attachinary-input").change ->
    file = $('.attachinary-input').val();
    if(file)
      file = file.substr(file.lastIndexOf("\\")+1);
      $(".click-to-browse").text(file);
