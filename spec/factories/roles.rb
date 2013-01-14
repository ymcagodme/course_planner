# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    name {"Role_#{rand(999)}"}
  end

  factory :user_role, :parent => :role do
    name "User"
  end

  factory :admin_role, :parent => :role do
    name "Admin"
  end
end
