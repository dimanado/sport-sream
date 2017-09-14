$ ->
  $("a[href=#]").click (e) ->
    e.preventDefault()
  $(".merchant-bar select#business_id").change ->
  	this.form.submit()