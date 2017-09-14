$ ->
  $("#categories_selector").accordion({ autoHeight: false, active: false, collapsible: true })

  $("#categories_selector .ui-accordion-header input").click (evt) ->
    top_category_checked = $(this).is (':checked')
    top_category_id = $(this).attr('value')
    subcategory_checkboxes = $("input[data-parent-category-id=#{top_category_id}]")
    subcategory_checkboxes.attr("checked", top_category_checked)
    evt.stopPropagation()

  $("#categories_selector div input").click (evt) ->
    parent_category_id = $(this).attr('data-parent-category-id')
    top_level_category = $("input[value=#{parent_category_id}]")
    top_level_category.attr("checked", false)
