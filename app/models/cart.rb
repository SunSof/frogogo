class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  
  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2,
    cancelled: 3
  }, default: :pending

  def self.current(session)
    cart_id = session[:cart_id]
    cart = cart_id ? find_by(id: cart_id) : nil
    
    if cart.nil?
      cart = create
      session[:cart_id] = cart.id
    end
    
    cart
  end

  def total
    cart_items.includes(:product).sum { |item| item.subtotal || 0 }
  end

  def empty?
    cart_items.empty?
  end
  
  def clear!
    cart_items.destroy_all
  end
end
