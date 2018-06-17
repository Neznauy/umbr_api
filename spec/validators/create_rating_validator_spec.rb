require 'rails_helper'

RSpec.describe CreateRatingValidator do
  let(:validator) do
    described_class.new(params).call
  end

  describe '#call' do
    context 'when valid params' do
      let!(:post) { create :post }
      let(:params) { {post_id: post.id, rating_value: 2} }

      it do
        expect(validator.output).to eq params
        expect(validator.errors).to eq({})
      end
    end
    
    context 'when excess params' do
      let!(:post) { create :post }
      let(:params) { {post_id: post.id, rating_value: 2, excess: true} }

      it do
        expect(validator.output).to eq params.without(:excess)
        expect(validator.errors).to eq({})
      end
    end


    context 'when no post_id' do
      let(:params) { {rating_value: 5} }

      it do
        expect(validator.errors).to include(post_id: ["is missing"])
      end
    end

    context 'when post does not exist' do
      let(:params) { {post_id: 1, rating_value: 5} }

      it do
        expect(validator.errors).to include(post_id: ["post does not exist"])
      end
    end

    context 'when no rating_value' do
      let(:post) { create :post }
      let(:params) { {post_id: post.id} }

      it do
        expect(validator.errors).to include(rating_value: ["is missing"])
      end
    end

    context 'when invalid rating_value' do
      let(:post) { create :post }
      let(:params) { {post_id: post.id, rating_value: 6} }

      it do
        expect(validator.errors).to include(rating_value: ["must be one of: 1, 2, 3, 4, 5"])
      end
    end
  end
end
