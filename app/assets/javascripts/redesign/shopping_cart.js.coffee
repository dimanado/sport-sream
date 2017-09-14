$(->
  shoppingCart =

    init: (config)->
      this.config = config
      this.addEvents()

    addEvents: ->
      obj = shoppingCart

      #namber field validation
      obj.config.numbersField.on('change', obj.itemValidator)
      obj.config.numbersField.on('focus', obj.itemValidator)

      #send cart
      obj.config.braintreeCheckout.on('click', obj.checkoutBtaintree)
      obj.config.payPalButton.on('click', obj.checkoutPayPal)

    checkoutPayPal: (e) ->
      obj = shoppingCart

      return false if !obj.config.numbersField.length
      obj.checkCart()
      return false if !obj.valid

    checkoutBtaintree: (e) ->
      obj = shoppingCart
      console.log 'lol' if !obj.config.numbersField.length
      return false if !obj.config.numbersField.length
      obj.checkCart()
      obj.config.form.submit() if obj.valid

    checkCart: ->
      obj = shoppingCart
      obj.valid = true


      obj.config.numbersField.each(->
        selfEachNum = $(this)
        obj.valid = false if !obj.itemValidator('', selfEachNum)
      )

    itemValidator: (e, self) ->
      obj = shoppingCart
      self = self || $(this)
      value = self.val()

      left = parseInt(self.data('left'))
      pattern = /\D+/g
      valueResult = value.replace(pattern, '')
      valid = true

      self.removeClass('errorField')

      if valueResult != value || valueResult == false || value == '0' || value == ''

        if value == '0'
          self.val('1').addClass('errorField')
        else
          self.val( if valueResult == '' then 1 else valueResult ).addClass('errorField')

        value = valueResult
        valid = false
        alert 'Please enter a valid number.'

      if left != -1 && left < parseInt(value)
        self.val(value = left).addClass('errorField')
        valid = false
        alert 'There are not enough items available.'

      sum = 0
      obj.config.numbersField.each(->
        selfEach = $(this)
        sum += parseInt(selfEach.val())
      )

      obj.config.summerField.text( "$"+(sum*1).toFixed(2) )
      obj.config.countItems.text(sum)

      $.get("/shopping_cart/save_amount", "id=" +self.data('id')+ "&amount=" +value)
      return valid

  #initialize shopping cart
  shoppingCart.init(
    form: $('.shopping_form'),
    numbersField: $('.cart-table .number'),
    summerField: $('.cart-table .summer'),
    countItems: $('.notifier'),
    braintreeCheckout: $('.braintree-checkout'),
    payPalButton: $('.pay_pal_button')
  )
)
