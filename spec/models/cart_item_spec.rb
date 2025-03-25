require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context 'instance methods' do
    describe '#subtotal' do
    let(:product) { create(:product, price: 1000) } 
    let(:cart) { create(:cart) } 
    let(:cart_item) { create(:cart_item, product: product, cart: cart, quantity:3) } 

      it "calculates the subtotal based on quantity and product price" do
        expect(cart_item.subtotal).to eq(3000)
      end

      it "returns 0 if quantity is 0" do
        cart_item.quantity = 0
        expect(cart_item.subtotal).to eq(0.0)
      end 
    end
  end 
end 