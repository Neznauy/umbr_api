require 'rails_helper'

RSpec.describe CreatePostValidator do
  let(:validator) do
    described_class.new(params).call
  end

  describe '#call' do
    context 'when valid params' do
      let(:params) do
        {
          post: {title: 'title1', content: 'content1', author_ip: '192.168.0.1'},
          user: {login: 'user1'}
        }
      end

      it do
        expect(validator.output).to eq params
        expect(validator.errors).to eq({})
      end
    end

    context 'when excess params' do
      let(:params) do
        {
          post: {title: 'title1', content: 'content1', author_ip: '192.168.0.1'},
          user: {login: 'user1'},
          excess: {excess: true}
        }
      end

      it do
        expect(validator.output).to eq params.without(:excess)
        expect(validator.errors).to eq({})
      end
    end

    context 'when no post title' do
      let(:params) do
        {
          post: {content: 'content1', author_ip: '192.168.0.1'},
          user: {login: 'user1'}
        }
      end

      it do
        expect(validator.errors).to include(post: hash_including(title: ["is missing"]))
      end
    end

    context 'when no post content' do
      let(:params) do
        {
          post: {title: 'title1', author_ip: '192.168.0.1'},
          user: {login: 'user1'}
        }
      end

      it do
        expect(validator.errors).to include(post: hash_including(content: ["is missing"]))
      end
    end

    context 'when no author_ip' do
      let(:params) do
        {
          post: {title: 'title1', content: 'content1'},
          user: {login: 'user1'}
        }
      end

      it do
        expect(validator.errors).to include(post: hash_including(author_ip: ["is missing"]))
      end
    end

    context 'when invalid author_ip' do
      let(:params) do
        {
          post: {title: 'title1', content: 'content1', author_ip: 'invalid_ip'},
          user: {login: 'user1'}
        }
      end

      it do
        expect(validator.errors).to include(post: hash_including(author_ip: ["invalid ip address"]))
      end
    end

    context 'when no user login' do
      let(:params) do
        {
          post: {title: 'title1', content: 'content1', author_ip: '192.168.0.1'},
          user: {}
        }
      end

      it do
        expect(validator.errors).to include(user: hash_including(login: ["is missing"]))
      end
    end
  end
end
