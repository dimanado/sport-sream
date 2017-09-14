#
#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#

window.qs = (key)->
    key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&");
    match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"))
    return match && decodeURIComponent(match[1].replace(/\+/g, " "))

chnki = this.chnki = {}

chnki.columnChart = (container, title, keys, series, options={})->
  result = {
    chart:
      renderTo: container,
      defaultSeriesType: 'column'
      backgroundColor: '#fafafa'
    title:
      text: title
    credits:
      enabled: false
    xAxis:
      categories: keys
    yAxis:
      allowDecimals: false,
      min: 0,
      title:
        text: ''
    legend:
      enabled: false
    tooltip:
      formatter: ->
        this.y
    plotOptions:
      column:
        minPointLength: 3
    series: [{
      name: ''
      data: series
      }]
  }

  $.extend(true, result, options)
  result

$ ->
  $('.subcategories').hide()
  $('a.collapse').click (e)->
    $(".subcategories[category='#{$(@).attr('category')}']").slideToggle()
    e.preventDefault()
