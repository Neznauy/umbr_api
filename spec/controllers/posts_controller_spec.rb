require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe '#create_post' do
    context "when valid params" do
      it do
        post :create_post,
             params: {
                post: {title: "title", content: "content", author_ip: "192.168.0.1"},
                user: {login: "user"}
             }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        parsed_response = JSON.parse(response.body).with_indifferent_access
        expect(parsed_response).to include(
          title: "title",
          content: "content",
          author_ip: "192.168.0.1"
        )
      end
    end

    context "when missed params" do
      it do
        post :create_post,
             params: {
                post: {content: "content", author_ip: "192.168.0.1"},
                user: {login: 'login'}
             }

        expect(response).to have_http_status(422)
        expect(response.content_type).to eq("application/json")

        parsed_response = JSON.parse(response.body).with_indifferent_access
        expect(parsed_response).to include(
          post: hash_including(title: ["is missing"])
        )
      end
    end
  end

  describe '#create_rating' do
    context "when valid params" do
      let(:first_post) { create :post }

      it do
        post :create_rating, params: { post_id: first_post.id, rating_value: 5 }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        parsed_response = JSON.parse(response.body).with_indifferent_access
        expect(parsed_response).to include(
          avg_rating: 5.0
        )
      end
    end

    context "when missed params" do
      let(:first_post) { create :post }

      it do
        post :create_rating, params: {rating_value: 5}

        expect(response).to have_http_status(422)
        expect(response.content_type).to eq("application/json")

        parsed_response = JSON.parse(response.body).with_indifferent_access
        expect(parsed_response).to include(
          post_id: ["is missing"]
        )
      end
    end
  end

  describe '#get_top_posts' do
    context "when valid params" do
      let!(:first_post) { create :post, avg_rating: 1 }
      let!(:second_post) { create :post, avg_rating: 2 }
      let!(:third_post) { create :post, avg_rating: 3 }

      it do
        post :get_top_posts, params: { quantity: 2 }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq 2
        expect(parsed_response.first['id']).to eq third_post.id
        expect(parsed_response.last['id']).to eq second_post.id
      end
    end

    context "when missed params" do
      it do
        post :get_top_posts, params: {}

        expect(response).to have_http_status(422)
        expect(response.content_type).to eq("application/json")

        parsed_response = JSON.parse(response.body).with_indifferent_access
        expect(parsed_response).to include(
          quantity: ["is missing"]
        )
      end
    end
  end

  describe '#get_ip_list' do
    before do
      2.times do |i|
        params = {
          post: {title: 'title1', content: 'content1', author_ip: '192.168.0.1'},
          user: {login: "user#{i}"}
        }
        CreatePostService.new(ActionController::Parameters.new(params)).call
      end
    end

    it do
      get :get_ip_list

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['192.168.0.1']).to include("user0", "user1")
    end
  end
end
