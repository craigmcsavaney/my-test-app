FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "123456789"
    password_confirmation { "123456789" }
  end
  factory :user_with_roles, parent: :user do
    Role.delete_all
    FactoryGirl.create(:role, name: 'User', description: "Logged In User")
    FactoryGirl.create(:role, name: 'SuperAdmin', description: "Logged in SuperUser")
  	after :create do |user|
  		user.role_ids = [Role.find_by_name("User").id,Role.find_by_name("SuperAdmin").id]
  	end
  end
  factory :user_with_merchants, parent: :user do
    after :create do |user|
      user.merchants = [1,2,3].map { |i| FactoryGirl.create(:merchant)}
    end
  end
  factory :user_with_causes, parent: :user do
    after :create do |user|
      user.causes = [1,2,3].map { |i| FactoryGirl.create(:cause)}
    end
  end
end