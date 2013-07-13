FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "123456789"
    password_confirmation { "123456789" }
  end
  factory :user_with_roles, parent: :user do
  	after :create do |user|
  		user.roles = [1,2,3].map { |i| FactoryGirl.create(:role)}
  	end
  end
  factory :user_with_merchants, parent: :user do
    after :create do |user|
      user.merchants = [1,2,3].map { |i| FactoryGirl.create(:merchant)}
    end
  end
end