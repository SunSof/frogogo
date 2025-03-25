class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  
  validate :discount_limit

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

  def discounted_total
    return total if discount.zero?
    # The final total cannot be lower than 100
    max_discount = [discount, total - 100].min
    [total - max_discount, 100].max
  end

  def items_count
    cart_items.sum(:quantity)
  end 

  def empty?
    cart_items.empty?
  end
  
  def clear!
    cart_items.destroy_all
  end

  private

  def discount_limit
    return if total <= 100
    
    max_discount = total - 100

    if discount > max_discount && max_discount > 0
      errors.add(:discount, "Скидка не может быть больше, чем сумма заказа")
    end
  end
end
