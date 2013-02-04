FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "person#{n}" }
    email { "#{username}@example.com" }
    password "123456"
    is_admin false
  end

  factory :admin, :class => User do
    sequence(:username) { |n| "admin#{n}" }
    email { "#{username}@example.com" }
    password "123456"
    is_admin true
  end
end
