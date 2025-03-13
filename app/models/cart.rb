class Cart < ApplicationRecord
  has_many :cart_items 
  has_many :products, through: :cart_items
  
  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2,
    cancelled: 3
  }, default: :pending

  def self.current(session)
    @current_cart ||= find_or_create_by(id: session[:cart_id])
    session[:cart_id] ||= @current_cart.id
    @current_cart
  end

  def total
    cart_items.sum { |item| item.subtotal }
  end

  def remove_product(product)
    cart_items.find_by(product_id: product.id)&.destroy
  end
end
