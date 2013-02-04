# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :code do |n|
    (21321 + n).to_s
  end
  
  factory :course do
    code 21321
    number 300
    title %w(CIS 300 - Ruby on Rails)
    instructor "David Huang"
    status "open"
    available_seats 30
    term
    department
  end
end
