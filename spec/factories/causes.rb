FactoryGirl.define do
  factory :cause do 
    sequence(:name) { |n| "Test Cause #{n}" }
  end
  factory :cause_with_users, parent: :cause do
  	after :create do |cause|
  		cause.users = [1,2,3].map { |i| FactoryGirl.create(:user_with_roles)}
  	end
  end
end