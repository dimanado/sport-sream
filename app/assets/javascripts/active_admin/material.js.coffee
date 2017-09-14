$(->
  material =
    is_sent: true

    init: (config) ->
      this.config = config
      this.addEvents()

    addEvents: ->
      obj = material
      obj.config.checkboxes.on('change', obj.checkingMaterial)
      $('#send_mail').on('click', obj.sendForm)

    sendForm: ->
      obj = material
      if obj.is_sent
        $(this).attr('disabled','disabled')
        $('#new_dispatch').submit()

    checkingMaterial: (e) ->
      obj = material
      self = $(this)
      number_of_checked_checkbox = 0

      obj.config.checkboxes.each(->
        if $(this).is(':checked')
          number_of_checked_checkbox++
      )

      $dispatch_form = $('#new_dispatch')
      $checkbox_hidden = $('<input id="m_'+self.val()+'" type="hidden" name="materials[]" value="'+self.val()+'">');

      if self.is(':checked')
        $dispatch_form.append($checkbox_hidden)
      else
        $dispatch_form.find("#m_"+self.val()).remove()

      if number_of_checked_checkbox == obj.config.number_attach_files
        obj.config.checkboxes.each(->
          $self_desable = $(this)
          if !$self_desable.is(':checked')
            $self_desable.attr('disabled','disabled')
            $self_desable.css('opacity','0.7')
        )
      else if number_of_checked_checkbox == obj.config.number_attach_files-1
        obj.config.checkboxes.each(->
          $self_enable = $(this)
          if $self_enable.is(":disabled")
            $self_enable.removeAttr('disabled')
            $self_enable.css('opacity','1')
        )

  #init material
  material.init({
    checkboxes: $('.material input[type=checkbox]'),
    number_attach_files: 3
  })
)