class CartItemsController < ApplicationController

  def update
    @cart_item = CartItem.find(params[:id])
    quantity = params[:quantity].to_i
    quantity = [1, quantity].max
    
    @cart_item.update(quantity: quantity)
    respond_to do |format|
      format.html { redirect_to cart_path }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("cart_item_#{@cart_item.id}", partial: "cart_items/cart_item", locals: { cart_item: @cart_item }),
          turbo_stream.replace("cart_summary", partial: "carts/summary", locals: { cart: current_cart  })
        ]
      end
    end
  end
  
  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Товар удален из корзины." }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@cart_item),
          turbo_stream.replace("carts", partial: "carts/summary")
        ]
      end
    end
  end
end
