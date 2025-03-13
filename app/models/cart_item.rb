class CartItem < ApplicationRecord
  belongs_to :cart 
  belongs_to :product

  def subtotal
    product.price * quantity
  end
end
