class CartsController < ApplicationController

  def show
    @cart_items = current_cart.cart_items.includes(product: { image_attachment: :blob })
  end

  def clear
    current_cart.clear!
    redirect_to cart_path
  end

  def update_discount
    discount = params[:discount_amount].to_i

    if current_cart.update(discount: discount)
      respond_with_success
    else
      respond_with_error("Неудалось обновить скидку.")
    end
  end

  private 

  def respond_with_success
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("discount_value", 
          html: helpers.number_to_currency(current_cart.discount, precision: 0, unit: '₽', format: '%n %u')),
          turbo_stream.replace("cart_summary", partial: "carts/summary", locals: { 
            cart: current_cart, 
            discount_amount: current_cart.discount
          })
        ]
      end
    end
  end 

  def respond_with_error(message)
    respond_to do |format|
      format.turbo_stream { flash.now[:alert] = message }
    end
  end
end
