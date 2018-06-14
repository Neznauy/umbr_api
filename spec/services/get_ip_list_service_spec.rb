require 'rails_helper'

RSpec.describe GetIpListService do
  let(:service) do
    described_class.new
  end

  describe '#call' do
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
      service.call
      expect(service.ips["192.168.0.1"]).to include("user0", "user1")
    end
  end
end
