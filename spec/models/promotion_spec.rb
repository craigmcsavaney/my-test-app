require 'spec_helper'

describe Promotion do

  it "has a valid factory" do
    FactoryGirl.create(:promotion_with_channels).should be_valid
  end

  let(:merchant) { FactoryGirl.create(:merchant) }
  
  before do
     @promotion = FactoryGirl.create(:promotion_with_channels, merchant: merchant)
  end

  subject { @promotion }

  it { should respond_to(:content) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:merchant_id) }
  it { should respond_to(:name) }
  it { should respond_to(:merchant) }
  it { should respond_to(:channel_ids) }
  its(:merchant) { should == merchant }

  it { should be_valid }

  describe "when merchant_id is not present" do
    before { @promotion.merchant_id = nil }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @promotion.name = nil }
    it { should_not be_valid }
  end

  describe "when name is blank" do
    before { @promotion.name = " " }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to merchant_id" do
      expect do
        Promotion.new(merchant_id: merchant.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

end