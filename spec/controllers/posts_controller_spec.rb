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
end
