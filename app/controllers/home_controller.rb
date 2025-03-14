class HomeController < ApplicationController
  def index
    if current_cart.empty?
      Product.all.each do |product|
        current_cart.cart_items.create(product: product, quantity: 1)
      end
    end
    
    redirect_to cart_path
  end
end