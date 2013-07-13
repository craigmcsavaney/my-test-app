FactoryGirl.define do
  factory :role do 
    sequence(:name) { |n| "Test Role #{n}" }
    description "Test role description"
  end
end