# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "person=#{n}@example.com"
  end

  factory :user do
    name "Test User from FactoryGirl"
    email "test@foobar.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
