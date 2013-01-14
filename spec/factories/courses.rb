# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :number do |n|
    (21321 + n).to_s
  end
  
  factory :course do
    number 21321
    title %w(CIS 300 - Ruby on Rails)
    instructor "David Huang"
    status "OPEN"
    available_seats 30
    term 1131
  end
end
