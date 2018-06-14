require 'rails_helper'

RSpec.describe CreateRatingService do
  let(:service) do
    described_class.new(ActionController::Parameters.new(params))
  end

  describe '#call' do
    context 'when valid params and post w/o rating' do
      let(:post) { create :post }
      let(:params) { {post_id: post.id, rating_value: 5} }

      it do
        service.call
        expect(service.avg_rating).to eq({avg_rating: 5})
      end
    end

    context 'when valid params and post with rating' do
      let!(:post) { create :post }
      let!(:first_rating) { create :rating, post_id: post.id, rating_value: 5 }
      let!(:second_rating) { create :rating, post_id: post.id, rating_value: 5 }
      let(:params) { {post_id: post.id, rating_value: 2} }

      it do
        service.call
        expect(service.avg_rating).to eq ({avg_rating: 4})
      end
    end

    context 'when no post_id' do
      let(:params) { {rating_value: 5} }

      it do
        service.call
        expect(service.errors).to include(post_id: ["is missing", "post does not exist"])
      end
    end

    context 'when post does not exist' do
      let(:params) { {post_id: 1, rating_value: 5} }

      it do
        service.call
        expect(service.errors).to include(post_id: ["post does not exist"])
      end
    end

    context 'when no rating_value' do
      let(:post) { create :post }
      let(:params) { {post_id: post.id} }

      it do
        service.call
        expect(service.errors).to include(rating_value: ["is missing", "must be one of: 1, 2, 3, 4, 5"])
        expect(post.reload.ratings.count).to eq 0
      end
    end

    context 'when invalid rating_value' do
      let(:post) { create :post }
      let(:params) { {post_id: post.id, rating_value: 6} }

      it do
        service.call
        expect(service.errors).to include(rating_value: ["must be one of: 1, 2, 3, 4, 5"])
        expect(post.reload.ratings.count).to eq 0
      end
    end
  end
end
