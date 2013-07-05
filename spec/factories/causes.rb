FactoryGirl.define do
  factory :cause do 
    sequence(:name) { |n| "Test Cause #{n}" }
  end
end