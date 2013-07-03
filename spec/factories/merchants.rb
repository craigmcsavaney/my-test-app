FactoryGirl.define do
  factory :merchant do 
    sequence(:name) { |n| "Test Merchant #{n}" }
  end
end