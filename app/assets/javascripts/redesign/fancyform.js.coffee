attemptLogin = ($form)->
  $errors = $form.find('.errors')
  $errors.text ''
  $errors.hide()

  $.ajax {
    type: 'POST'
    url: $form.attr('action')
    data: $form.serialize()
    success: (response)->
      if response.success
        window.location = response.redirect
      else
        $errors.fadeIn(500)
        $errors.append response.errors[0]
    error: (response)->
      $errors.fadeIn(500)
      $errors.append 'There was a problem logging in.'
  }

clearForm = ($form)->
  $form.find('.ffdata').remove()


addModalParams = ($form)->
  modalParams = $form.parent().parent().attr 'params'
  return unless modalParams
  console.log modalParams
  entries = modalParams.split('&')
  for entry in entries
    splits = entry.split('=')
    $input = $('<input></input')
      .attr('name', splits[0])
      .val(splits[1])

    $('<div></div>')
      .addClass('.ffdata')
      .hide()
      .append($input)
      .appendTo($form)


attemptSignup = ($form)->
  clearErrors($form)
  $signupBtn = $form.find('input[type=submit]')
  $signupBtn.val 'Registering...'
  addModalParams($form)

  $.ajax {
    type: 'POST'
    url: $form.attr('action')
    data: $form.serialize()
    dataType: 'json'
    success: (response)->
      if response.success
        $signupBtn.val 'Success!'
        window.location = response.redirect
      else
        resource_name = $form.attr('class').split('_')[1]
        highlightErrorsFor $form, resource_name, response.errors
      clearForm $form
    error: (response)->
      console.error response
      clearForm $form
  }


clearErrors = ($form)->
  $form.find('label .fieldErrors').remove()
  $form.find('.invalid').removeClass('invalid')
  $signupBtn = $form.find('input[type=submit]')
  $signupBtn.val $signupBtn.attr('data-label')


messages = (errs)->
  error = errs[0] || 'A value must be specified'
  $('<div></div>')
    .addClass('fieldErrors')
    .text("#{error}")


highlightErrorsFor = ($form, resource, errors)->
  $signupBtn = $form.find('input[type=submit]')
  $signupBtn.val $signupBtn.attr('data-label')
  console.log '-----------------ERR-------------'
  console.log errors
  console.log '---------------------------------'
  for field,errs of errors
    name = field.split('.')
    if name.length > 1
      id = "#{name[0].slice(0, -2)}_#{name[1]}"
    else
      id = "#{resource}_#{name}"
    console.log id
    query = '#' + id
    $elem = $form.find(query)
    $label = $form.find 'label[for="' + id + '"]'
    $label.append messages(errs)

    if $elem.parent().hasClass 'inline'
      $elem.parent().addClass 'invalid'
    else
      $elem.addClass 'invalid'

    ###
    if names.length > 1
      resource = names[0].slice(0, -2)
      console.log 'recursive!!!'
      console.log resource
      nested_errors = {}
      nested_errors[names[1]] = errs
      highlightErrorsFor $form, resource, nested_errors
    else
      name = "#{resource}[#{field}]"
      id = "#{resource}_#{field}"
      console.log id
      query = '#' + id
      $elem = $form.find(query)
      $label = $form.find 'label[for="' + id + '"]'
      $label.append messages(errs)

      if $elem.parent().hasClass 'inline'
        $elem.parent().addClass 'invalid'
      else
        $elem.addClass 'invalid'
    ###

$ ->
  $('*[data-form="fancyform_login"]').each (i,e)->
    $form = $(e).find 'form'
    $form.find('.errors').hide()
    $submit = $form.find('input[type="submit"]')
    $submit.click (e)->
      e.preventDefault()
      attemptLogin $form

  $('*[data-form="fancyform_signup"]').each (i,e)->
    $form = $(e).find 'form'
    $(window).bind 'modalhide', ->
      clearForm $form
      clearErrors $form
    $submit = $form.find('input[type="submit"]').click (e)->
      e.preventDefault()
      attemptSignup $form
    $submit.attr 'data-label', $submit.val()


  $('#business_online_business').change ->
    $('.not_online').toggle()