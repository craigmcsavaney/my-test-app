require 'spec_helper'

describe "served_promotions/show" do
  before(:each) do
    @served_promotion = assign(:served_promotion, stub_model(ServedPromotion))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
