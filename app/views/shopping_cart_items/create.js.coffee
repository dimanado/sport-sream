minicart = $('.dropdown-list.cart-list.clearfix')
minicart.html('<%= j render partial: 'shopping_carts/minishow' %>')
$('small.notifier').html('<%= shopping_cart.quantity %>')
minicart.toggle()
window.scroll 0,0
