require 'rails_helper'

RSpec.describe GetTopPostsService do
  let(:service) do
    described_class.new(ActionController::Parameters.new(params))
  end

  describe '#call' do
    context 'when valid params' do
      let!(:first_post) { create :post, avg_rating: 5 }
      let!(:second_post) { create :post, avg_rating: 1 }
      let(:params) { {quantity: 1} }

      it do
        service.call
        expect(service.posts).to eq [first_post]
      end
    end

    context 'when no quantity' do
      let(:params) { {} }

      it do
        service.call
        expect(service.errors).to include(quantity: ["is missing"])
      end
    end

    context 'when invalid quantity' do
      let(:params) { {quantity: 'invalid'} }

      it do
        service.call
        expect(service.errors).to include(quantity: ["must be greater than 0"])
      end
    end
  end
end
