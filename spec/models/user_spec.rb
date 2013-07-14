require 'spec_helper'

describe User do

	it "has a valid factory" do
		FactoryGirl.create(:user).should be_valid
	end

  it "has a valid factory" do
    FactoryGirl.create(:user_with_roles).should be_valid
  end
  
  before  do
    @user = FactoryGirl.create(:user)
  end

  subject { @user }

  it { should respond_to(:email) }

  it { should be_valid }

  describe "when email is not present" do
    before { @user.email = nil }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = "1234567" }
    it { should_not be_valid }
  end

  describe "when passwords don't match" do
    before { @user.password_confirmation = "" }
    it { should_not be_valid }
  end

  describe "enforce uniqueness" do
    it "should not add a duplicate user" do
      user_with_same_name = @user.dup
      user_with_same_name.should_not be_valid
    end
  end
end