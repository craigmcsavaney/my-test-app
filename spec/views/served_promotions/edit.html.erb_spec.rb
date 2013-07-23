require 'spec_helper'

describe "served_promotions/edit" do
  before(:each) do
    @served_promotion = assign(:served_promotion, stub_model(ServedPromotion))
  end

  it "renders the edit served_promotion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => served_promotions_path(@served_promotion), :method => "post" do
    end
  end
end
