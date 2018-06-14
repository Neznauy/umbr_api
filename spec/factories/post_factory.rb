FactoryBot.define do
  factory :post do
    sequence(:title) {|n| "title_#{n}"}
    sequence(:content) {|n| "content_#{n}"}
    author_ip '192.168.0.1'
    user

    factory :post_with_ratings do
      transient { posts_count 2 }
      after(:create) do |post, evaluator|
        create_list(:rating, evaluator.posts_count, post: post)
      end
    end
  end
end
