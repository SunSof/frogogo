require 'rails_helper'

RSpec.describe CartsController, type: :request do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_cart).and_return(cart)
  end

  describe "GET /cart (show action)" do
    it "renders the show template and assigns cart_items" do
      get cart_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(cart_item.product.name)
    end
  end

  describe "DELETE /cart/clear" do
    it "clears the cart and redirects" do
      expect { delete clear_cart_path }.to change { cart.cart_items.count }.to(0)
      expect(response).to redirect_to(cart_path)
    end
  end

  describe "PATCH /cart/update_discount" do
    context "when update is successful" do
      it "updates the discount and responds with Turbo Stream" do
        patch update_discount_cart_path, 
              params: { discount_amount: 200 }, 
              headers: { "Accept" => "text/vnd.turbo-stream.html" }

        expect(response).to have_http_status(:ok)
        expect(cart.reload.discount).to eq(200)
        expect(response.body).to include("<turbo-stream action=\"update\" target=\"discount_value\"")
      end
    end

    context 'with failed discount update' do
      it 'sets alert when update fails' do    
        allow(cart).to receive(:update).with(discount: 100).and_return(false)
    
        patch update_discount_cart_path, 
              params: { discount_amount: 100 }, 
              headers: { "Accept" => "text/vnd.turbo-stream.html" }
    
        expect(response.body).to include('turbo-stream action="update" target="discount_form_messages"')
        expect(response.body).to include('Неудалось обновить скидку')
      end
    end
  end
end