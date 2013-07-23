FactoryGirl.define do
  factory :promotion do
    Promotion.delete_all
    content "Ipsum Lorem"
#    merchant_id "1"   
    start_date "07/01/2013"
    end_date "06/30/2014"
    sequence(:name) { |n| "Test Promotion #{n}" }
    merchant
    landing_page "http://www.example.com"
    merchant_pct "5"
    cause
  end
  factory :promotion_with_channels, parent: :promotion do
  	after :create do |promotion|
  		promotion.channels = [1,2,3].map { |i| FactoryGirl.create(:channel)}
  	end
  end
end