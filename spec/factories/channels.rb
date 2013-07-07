FactoryGirl.define do
  factory :channel do 
    sequence(:name) { |n| "Test Channel #{n}" }
    sequence(:awesm_id) { |n| "Awe.SM ID#{n}" }
    sequence(:description) { |n| "Test description#{n}" }
  end
end