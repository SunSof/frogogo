require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, id: 1, cart: cart, product: product) }
  
  describe "PATCH #update" do
    context "when update is successful" do
      it "updates the cart item quantity" do
        allow(cart_item).to receive(:update).with({ "quantity" => "3"}).and_return(true)
        
        patch :update, params: { id: "1", cart_item: { quantity: "3" } }
        
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when deletion is successful" do  
      it "removes the cart item and renders updated cart" do
        allow(cart_item).to receive(:destroy).and_return(true)

        delete :destroy, params: { id: "1"}

        expect(response).to have_http_status(302)
      end
    end
  end
  
  describe "Error handling" do
    context "when cart item is not found" do
      before do
        allow(CartItem).to receive(:find).with("999").and_raise(ActiveRecord::RecordNotFound)
      end
      
      it "redirects to cart path" do
        patch :update, params: { id: "999", quantity: 3 }
        expect(response).to redirect_to(cart_path)
      end
    end
    
    context "when cart item doesn't belong to current cart" do
      before do
        # Setup cart item that belongs to a different cart
        other_cart_item = instance_double('CartItem', id: 2, cart_id: 999)
        allow(CartItem).to receive(:find).with("2").and_return(other_cart_item)
        allow(other_cart_item).to receive(:cart_id).and_return(999)
      end
      
      it "redirects to cart path" do
        patch :update, params: { id: "2", quantity: 3 }
        expect(response).to redirect_to(cart_path)
      end
    end
  end
end
