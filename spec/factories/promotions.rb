FactoryGirl.define do
  factory :promotion do
    content "Ipsum Lorem"
#    merchant_id "1"   
    start_date "07/01/2013"
    end_date "06/30/2014"
    sequence(:name) { |n| "Test Promotion #{n}" }
    merchant
  end
end