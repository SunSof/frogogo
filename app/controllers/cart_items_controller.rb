class CartItemsController < ApplicationController

  def update
    @cart_item = CartItem.find(params[:id])
    quantity = params[:quantity].to_i
    quantity = [1, quantity].max
    
    @cart_item.update(quantity: quantity)
    respond_to do |format|
      format.turbo_stream 
      format.html { redirect_to cart_path }
    end
  end
  
  def destroy
    @cart_item.destroy
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path }
    end
  end
end
