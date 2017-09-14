class ShoppingCartsController < ApplicationController
  layout "pages"

  def save_amount
    shopping_cart.quantity_all = params[:quantity_all]
    shopping_cart.save
    @offer = shopping_cart.shopping_cart_items.find(params[:id])
    @offer.quantity = params[:amount].to_i
    @offer.save
    respond_to :js
  end

end
