FactoryGirl.define do
  factory :merchant do 
    sequence(:name) { |n| "Test Merchant #{n}" }
  end
  factory :merchant_with_users, parent: :merchant do
  	after :create do |merchant|
  		merchant.users = [1,2,3].map { |i| FactoryGirl.create(:user)}
  	end
  end
end