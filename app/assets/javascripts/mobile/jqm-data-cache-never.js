$('div').live('pagehide', function(event, ui){
  var page = $(event.target);

  if(page.attr('data-cache') == 'never'){
    page.remove();
  };
});

