class ShoppingCartItemsController < ApplicationController
  respond_to :js

  def create
    shopping_cart.add(Coupon.find(params[:offer_id]), 1)
  end

  def destroy
    ShoppingCartItem.destroy( params[:id] )
    respond_to do |format|
      format.html { redirect_to shopping_cart_path }
      format.js
    end
  end

  def change_quantity
    ShoppingcartItem.find(params[:id]).update_attribute(:quantity, params[:new_quantity])
  end

end
