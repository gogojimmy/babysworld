# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consignment do
    user_id 1
    name "MyString"
    address "MyString"
    phone "MyString"
    status "MyString"
  end
end
