require 'spec_helper'

describe "served_promotions/new" do
  before(:each) do
    assign(:served_promotion, stub_model(ServedPromotion).as_new_record)
  end

  it "renders new served_promotion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => served_promotions_path, :method => "post" do
    end
  end
end
