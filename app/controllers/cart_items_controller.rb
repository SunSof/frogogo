class CartItemsController < ApplicationController

  def update
    @cart_item.update(cart_item_params)
  end
  
  def destroy
    @cart_item.destroy
  end

  private 

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
