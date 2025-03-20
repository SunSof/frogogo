class CartsController < ApplicationController
  before_action :set_discount_amount, only: [:show, :slider_discount]

  def show
    @cart_items = current_cart.cart_items.includes(product: { image_attachment: :blob })
  end

  def clear
    current_cart.clear!
    redirect_to cart_path
  end

  def slider_discount
    @discount_amount = params[:discount_amount]

    formatted_discount = helpers.number_to_currency(@discount_amount, precision: 0, unit: '₽', format: '%n %u')

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("discount_value", html: formatted_discount),
          turbo_stream.replace("cart_summary", partial: "carts/summary", locals: { 
            cart: current_cart, 
            discount_amount: @discount_amount 
          })
        ]
      end
    end
  end 

  private
  
  def set_discount_amount
    @discount_amount = session[:discount_amount] || 0
  end

end
