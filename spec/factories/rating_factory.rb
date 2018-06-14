FactoryBot.define do
  factory :rating do
    sequence(:rating_value) {|n| (n % 5 + 1)}
    post
  end
end
