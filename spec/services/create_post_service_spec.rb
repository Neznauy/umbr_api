require 'rails_helper'

RSpec.describe CreatePostService do
  let(:service) do
    described_class.new(ActionController::Parameters.new(params))
  end

  describe '#call' do
    before { service.call }
    
    context 'when valid params' do
      let(:params) do
        {
          post: {title: 'title1', content: 'content1', author_ip: '192.168.0.1'},
          user: {login: 'user1'}
        }
      end

      it do
        expect(service.post.title).to eq 'title1'
        expect(service.post.content).to eq 'content1'
        expect(service.post.author_ip).to eq '192.168.0.1'

        expect(service.post.user.login).to eq 'user1'
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
        expect(service.errors).to include(post: hash_including(title: ["is missing"]))
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
        expect(service.errors).to include(post: hash_including(content: ["is missing"]))
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
        expect(service.errors).to include(post: hash_including(author_ip: ["is missing", "invalid ip address"]))
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
        expect(service.errors).to include(post: hash_including(author_ip: ["invalid ip address"]))
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
        expect(service.errors).to include(user: hash_including(login: ["is missing"]))
      end
    end
  end
end
