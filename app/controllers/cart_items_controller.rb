class CartItemsController < ApplicationController
  before_action :set_cart_item, :set_cart, :ensure_cart_ownership

  def update
    quantity = [1, params[:quantity].to_i].max

    if @cart_item.update(quantity: quantity)
      respond_with_success
    else
      respond_with_error("Неудалось обновить количество.")
    end
  end
  
  def destroy
    if @cart_item.destroy
      respond_with_removal
    else
      respond_with_error("Не удалось удалить элемент из корзины.")
    end
  end

  def respond_with_success
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("cart_item_#{@cart_item.id}", partial: "cart_items/cart_item", locals: { cart_item: @cart_item }),
          turbo_stream.replace("cart_summary", partial: "carts/summary", locals: { cart: @cart })
        ]
      end
    end
  end

  def respond_with_removal
    respond_to do |format|
      format.turbo_stream do
        if @cart.empty?
          render turbo_stream: [
            turbo_stream.replace("cart_header", partial: "carts/cart_header", locals: { cart: @cart }),
            turbo_stream.replace("cart_items_container", partial: "carts/empty_cart")
          ]
        else
          render turbo_stream: [
            turbo_stream.remove(@cart_item),
            turbo_stream.replace("cart_summary", partial: "carts/summary", locals: { cart: @cart })
          ]
        end
      end
    end
  end

  def respond_with_error(message)
    respond_to do |format|
      format.turbo_stream { flash.now[:alert] = message }
    end
  end

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to cart_path and return
  end

  def set_cart
    @cart = current_cart
  end

  def ensure_cart_ownership
    unless @cart_item.cart_id == @cart.id
      redirect_to cart_path and return
    end
  end
end
