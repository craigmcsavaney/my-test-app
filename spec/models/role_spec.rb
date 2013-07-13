require 'spec_helper'

describe Role do

	it "has a valid factory" do
		FactoryGirl.create(:role).should be_valid
	end

  before  do
    @role = FactoryGirl.create(:role)
  end

  subject { @role }

  it { should respond_to(:name) }

  it { should be_valid }

  describe "when name is not present" do
    before { @role.name = nil }
    it { should_not be_valid }
  end

  describe "when name is blank" do
    before { @role.name = " " }
    it { should_not be_valid }
  end

  describe "enforce uniqueness" do
    it "should not add a duplicate" do
      role_with_same_name = @role.dup
      role_with_same_name.should_not be_valid
    end
  end
end