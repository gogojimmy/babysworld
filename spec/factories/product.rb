FactoryGirl.define do
  factory :product do
    association :user
    sequence(:name) { |n| "person#{n}" }
    description "BlahBlah"
    original_price 1000
    status "waiting_for_review"
    is_public false
    price 500
    url "http://something.com"
  end
end
