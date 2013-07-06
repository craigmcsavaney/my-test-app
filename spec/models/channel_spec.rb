require 'spec_helper'

describe Channel do

	it "has a valid factory" do
		FactoryGirl.create(:channel).should be_valid
	end

  before  do
    @channel = FactoryGirl.create(:channel)
  end

  subject { @channel }

  it { should respond_to(:name) }

  it { should be_valid }

  describe "when name is not present" do
    before { @channel.name = nil }
    it { should_not be_valid }
  end

  describe "when name is blank" do
    before { @channel.name = " " }
    it { should_not be_valid }
  end

  describe "enforce uniqueness" do
    it "should not add a duplicate" do
      channel_with_same_name = @channel.dup
      channel_with_same_name.should_not be_valid
    end
  end
end