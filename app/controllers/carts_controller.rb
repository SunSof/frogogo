class CartsController < ApplicationController
  
  def show 
    @cart_items = current_cart.cart_items.includes(:product)
  end 

  def clear
    current_cart.cart_items.destroy_all
    redirect_to cart_path
  end
end
