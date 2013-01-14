# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "person=#{n}@example.com"
  end

  factory :user do
    name "normal user"
    email "test@foobar.com"
    password "foobar"
    password_confirmation "foobar"
    confirmed_at Time.now.utc
    after(:create) {|user| user.add_role(:user)}
  end

  factory :admin, :parent => :user do
    after(:create) {|user| user.add_role(:admin)}
  end
end
