require 'spec_helper'

describe Cause do

	it "has a valid factory" do
		FactoryGirl.create(:cause).should be_valid
	end

  before  do
    @cause = FactoryGirl.create(:cause)
  end

  subject { @cause }

  it { should respond_to(:name) }

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