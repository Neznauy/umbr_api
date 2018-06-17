require 'rails_helper'

RSpec.describe ApplicationSchema do
  describe '#ip?' do
    let(:schema) do
      Dry::Validation.Schema(described_class) do
        required(:sample).value(:ip?)
      end
    end

    context 'when valid' do
      let(:input) { {sample: '192.168.1.1'} }

      it { expect(schema.call(input).success?).to be_truthy }
    end

    context 'when invalid' do
      let(:input) { {sample: 'invalid'} }

      it { expect(schema.call(input).success?).to be_falsey }
    end
  end

  describe '#post_exist?' do
    let(:schema) do
      Dry::Validation.Schema(described_class) do
        required(:sample).value(:post_exist?)
      end
    end

    context 'when valid' do
      let(:post) { create :post }
      let(:input) { {sample: post.id} }

      it { expect(schema.call(input).success?).to be_truthy }
    end

    context 'when invalid' do
      let(:input) { {sample: 111} }

      it { expect(schema.call(input).success?).to be_falsey }
    end
  end
end
