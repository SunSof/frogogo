class CartsController < ApplicationController

  def show 
    @cart_items = current_cart.cart_items.includes(:product)
  end 

end
