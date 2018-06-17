require 'rails_helper'

RSpec.describe GetTopPostsValidator do
  let(:validator) do
    described_class.new(params).call
  end

  describe '#call' do
    context 'when valid params' do
      let(:params) { {quantity: 1} }

      it do
        expect(validator.output).to eq params
        expect(validator.errors).to eq({})
      end
    end

    context 'when excess params' do
      let(:params) { {quantity: 1, excess: true} }

      it do
        expect(validator.output).to eq params.without(:excess)
        expect(validator.errors).to eq({})
      end
    end

    context 'when no quantity' do
      let(:params) { {} }

      it do
        expect(validator.errors).to include(quantity: ["is missing"])
      end
    end

    context 'when invalid quantity' do
      let(:params) { {quantity: 'invalid'} }

      it do
        expect(validator.errors).to include(quantity: ["must be an integer"])
      end
    end
  end
end
