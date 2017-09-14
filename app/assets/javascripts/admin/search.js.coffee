do_search = (text)->
  if text.length > 0
    window.location.search = "search=#{text}"
  else
    window.location.search = ""

make_searchable = (container)->
  $(container).keyup (e)->
    do_search($(@).val()) if e.keyCode is 13
  
  $(container).val(qs('search'))
  if qs('search')
    if $('.table tbody').children().length is 0
      $('.table').replaceWith '<h1>Search gave no results</h1>'

$ -> make_searchable $('#search')