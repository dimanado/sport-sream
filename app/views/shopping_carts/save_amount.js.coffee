minicart = $('.dropdown-list.cart-list.clearfix')
minicart.html('<%= j render partial: 'shopping_carts/minishow' %>')
$.post("/checkout/set_tr")