$ ->
  $('#photo_category').change ->
    cat = $("#photo_category").val()
    $.ajax {
      type: 'GET'
      url: "/photos"
      dataType: 'html'
      data: {category: cat}
      success: (data)->
        $("#results").html data
      error: (response)->
        console.error response
    }
  $('.showMyPhotos').click ->
    $.ajax {
      type: 'GET'
      url: "/business/"+curBusinessID+"/images"
      dataType: 'html'
      success: (data)->
        $("#results").html data
      error: (response)->
        console.error response
    }
