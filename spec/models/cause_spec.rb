require 'spec_helper'

describe Cause do

	it "has a valid factory" do
		FactoryGirl.create(:cause).should be_valid
	end

  it "has a valid factory with users" do
    FactoryGirl.create(:cause_with_users).should be_valid
  end
  
  before  do
    @cause = FactoryGirl.create(:cause_with_users)
  end

  subject { @cause }

  it { should respond_to(:name) }
  it { should respond_to(:user_ids) }

  it { should be_valid }

  describe "when name is not present" do
    before { @cause.name = nil }
    it { should_not be_valid }
  end

  describe "when name is blank" do
    before { @cause.name = " " }
    it { should_not be_valid }
  end

  describe "enforce uniqueness" do
    it "should not add a duplicate" do
      cause_with_same_name = @cause.dup
      cause_with_same_name.should_not be_valid
    end
  end
end