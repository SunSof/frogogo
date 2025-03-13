class Cart < ApplicationRecord
  has_many :cart_items 
  has_many :products, through: :cart_items
  
  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2,
    cancelled: 3
  }, default: :pending
end
