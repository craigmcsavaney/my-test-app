FactoryGirl.define do
  factory :channel do 
    sequence(:name) { |n| "Test Channel #{n}" }
    awesm_id "Test Awe.sm ID"
    description "Test description"
  end
end