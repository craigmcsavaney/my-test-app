require 'spec_helper'

describe "Merchant pages" do

    subject { page }

    describe "new merchant page" do
	    before { visit new_merchant_path }

	    it { should have_selector('h1',    text: 'Sign up') }
	    it { should have_selector('title', text: full_title('Sign up')) }

		describe "create merchant" do

		    before { visit new_merchant_path }

		    let(:submit) { "Create new merchant" }

		    describe "with invalid information" do
		        it "should not create a merchant" do
		        	expect { click_button submit }.not_to change(Merchant, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_selector('title', text: 'Sign up') }
		        	it { should have_content('error') }
		        end
		    end

		    describe "with valid information" do
		        before do
		        	fill_in "Name",         with: "Example Merchant"
		        end

		        it "should create a merchant" do
		        	expect { click_button submit }.to change(Merchant, :count).by(1)
		        end
		        describe "after creating the merchant" do
			        before { click_button submit }
#			        let(:merchant) { Merchant.find_by_name('Example Merchant') }

			        it { should have_selector('title', text: full_title('Sign up')) }
			        it { should have_selector('div.alert.alert-success', text: 'New Merchant has been created') }
			     end
		    end
		end
    end
end