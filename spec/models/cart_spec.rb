require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'validates' do
    describe '#discount_limit' do 
      let(:product) { create(:product, price: 1000) } 
      let(:cart) { create(:cart, discount: 1000) } 
      before do
        create(:cart_item, cart: cart, product: product, quantity: 1)
      end
      
      it "is invalid with discount exceeding max allowed" do
        expect(cart).not_to be_valid
        expect(cart.errors[:discount]).to include("Скидка не может быть больше, чем сумма заказа")
      end
    end 
  end

  context 'class methods' do
    describe '::current' do
      it "creates a new cart and stores its id in the session" do
        session = {}
        
        expect {
          @cart = Cart.current(session)
        }.to change(Cart, :count).by(1)
        
        expect(@cart).to be_a(Cart)
        expect(@cart.persisted?).to be true
        expect(session[:cart_id]).to eq(@cart.id)
      end

      it "returns the existing cart" do
        existing_cart =  create(:cart)
        session = { cart_id: existing_cart.id }
        
        expect {
          @cart = Cart.current(session)
        }.not_to change(Cart, :count)
        
        expect(@cart).to eq(existing_cart)
        expect(session[:cart_id]).to eq(existing_cart.id)
      end
    end
  end

  context 'instance methods' do
    describe '#total' do
      let(:cart) { create(:cart) }
      let(:product1) { create(:product, price: 50) }
      let(:product2) { create(:product, price: 100) } 

      it "returns 0 when cart is empty" do
        expect(cart.total).to eq(0)
      end

      context "when cart has items" do
        before do
          create(:cart_item, cart: cart, product: product1, quantity: 2)
          create(:cart_item, cart: cart, product: product2, quantity: 1)
        end
        
        it "returns the sum of all item subtotals" do
          expect(cart.total).to eq(200)
        end
      end
    end

    describe "#discounted_total" do 
    let(:cart) { create(:cart) }
    let(:product) { create(:product, price: 500) }

      context "when total is less than 100" do
        before do
          create(:cart_item, cart: cart, product: product, quantity: 1)
        end
        
        it "returns the minimum total of 100" do
          cart.discount = 500
          expect(cart.discounted_total).to eq(100)
        end
      end

      context "when total is more than 100" do
        before do
          create(:cart_item, cart: cart, product: product, quantity: 3) 
        end
        
        it "returns the minimum total of 100" do
          cart.discount = 500
          expect(cart.discounted_total).to eq(1000)
        end
      end

      context "when discount 0" do
        before do
          create(:cart_item, cart: cart, product: product, quantity: 1)
        end
      
        it "set no discount total" do
          cart.discount = 0
          expect(cart.discounted_total).to eq(500)
        end
      end 
    end 

    describe "#item_count" do 
      let(:cart) { create(:cart) }
      let(:product1) { create(:product, price: 500) }
      let(:product2) { create(:product, price: 400) }

      it "when cart is empty returns 0" do
        expect(cart.items_count).to eq(0)
      end
      
      context "when cart has items" do
        before do
          create(:cart_item, cart: cart, product: product1, quantity: 2)
          create(:cart_item, cart: cart, product: product2, quantity: 3)
        end
        
        it "returns the sum of all item quantities" do
          expect(cart.items_count).to eq(5)
        end
      end
    end

    describe "#empty?" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    
      it "returns true when cart has no items" do
        expect(cart.empty?).to be true
      end

      context "when cart has items" do
        before do
          create(:cart_item, cart: cart, product: product)
        end
        
        it "returns false" do
          expect(cart.empty?).to be false
        end
      end
    end

    describe "#clear!" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    
      context "when cart has items" do
        before do
          create(:cart_item, cart: cart, product: product, quantity: 2)
        end
        
        it "removes all items from the cart" do
          expect {
            cart.clear!
          }.to change { cart.cart_items.count }.from(1).to(0)
          
          expect(cart.empty?).to be true
        end
      end
    end
  end 
end 