require 'spec_helper'

describe "Promotion pages" do

  subject { page }

  describe "create promotion page" do
    before { visit create_promotion_path }

    it { should have_selector('h1',    text: 'Create Promotion') }
    it { should have_selector('title', text: full_title('Create Promotion')) }

		describe "create promotion" do

		    before { visit create_promotion_path }

		    let(:submit) { "Create" }

		    describe "with invalid information" do
		        it "should not create a promotion" do
		        	expect { click_button submit }.not_to change(Promotion, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_selector('title', text: full_title('Create Promotion')) }
		        	it { should have_content('error') }
		        end
		    end

		    describe "with valid information" do
		        before do
		        	fill_in "Name",         with: "Example Promotion"
		        	fill_in "Merchant ID",	with: "1"
		        	fill_in "Start Date",	with: "07/01/2013"
		        	fill_in "End Date",		with: "06/30/2014"
		        end

		        it "should create a promotion" do
		        	expect { click_button submit }.to change(Promotion, :count).by(1)
		        end
		        describe "after creating the promotion" do
			        before { click_button submit }
#			        let(:merchant) { Merchant.find_by_name('Example Merchant') }

			        it { should have_selector('title', text: full_title('Create Promotion')) }
			        it { should have_selector('div.alert.alert-success', text: 'New Promotion has been created') }
			     end
		    end
		end
    end
end