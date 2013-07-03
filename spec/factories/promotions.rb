FactoryGirl.define do
  factory :promotion do
    content "Ipsum Lorem"
#    merchant_id "1"   
    start_date "07/01/2013"
    end_date "06/30/2014"
    name "Test Name"
    merchant
  end
end