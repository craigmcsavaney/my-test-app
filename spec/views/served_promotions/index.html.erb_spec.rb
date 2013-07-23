require 'spec_helper'

describe "served_promotions/index" do
  before(:each) do
    assign(:served_promotions, [
      stub_model(ServedPromotion),
      stub_model(ServedPromotion)
    ])
  end

  it "renders a list of served_promotions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
