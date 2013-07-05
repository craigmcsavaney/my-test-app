require 'spec_helper'

describe "Merchant pages" do

    subject { page }

    describe "index" do
    	before do
    		FactoryGirl.create(:merchant)
    		visit merchants_path
    	end

    	it { should have_selector('h1', text: 'All Merchants') }
    	it { should have_selector('title',    text: full_title('All Merchants')) }

    	it "should list each merchant" do
    		Merchant.all.each do |merchant|
    			page.should have_selector('li', text: merchant.name)
    		end
    	end

    	describe "pagination" do

    		before(:all) { 30.times { FactoryGirl.create(:merchant) } }
    		after(:all)  { Merchant.delete_all }

    		it { should have_selector('div.pagination') }

    		it "should list each merchant" do
    			Merchant.paginate(page: 1).each do |merchant|
    				page.should have_selector('li', text: merchant.name)
    			end
    		end
    	end
    end

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

			        it { should have_selector('title', text: full_title('All Merchants')) }
			        it { should have_selector('div.alert.alert-success', text: 'New Merchant has been created') }
			     end
		    end
		end
    end

    describe "edit" do
	    before do
	    	Merchant.delete_all
	    	!FactoryGirl.create(:merchant, name: 'Merchant1')
	    	!FactoryGirl.create(:merchant, name: 'Merchant2')
	    	@merchant2 = Merchant.find_by_name('Merchant2') 
	    end

	    before { visit edit_merchant_path(@merchant2.id) }

	    describe "page" do
		    it { should have_selector('h1',    text: 'Edit Merchant') }
		    it { should have_selector('title', text: full_title('Edit Merchant')) }
		    # it { should have_css('Merchant2') }  # Can't figure out how to identify this page
		    # # as the exact page I'm looking for, but it clearly is the correct page.
		end

	    describe "with invalid merchant name" do
	    	before do
	    		fill_in "Name",				with: " "
	    	end
        	before { click_button "Save changes" }

	        	it { should have_selector('title', text: full_title('Edit Merchant')) }
	        	it { should have_content('error') }
	    end

	    describe "with duplicate merchant name" do
	    	before do
	    		fill_in "Name",				with: "Merchant1"
	    	end
        	before { click_button "Save changes" }

	        	it { should have_selector('title', text: full_title('Edit Merchant')) }
	        	it { should have_content('error') }
	    end

	    describe "with valid information" do
	        before do
	        	fill_in "Name",         with: "Merchant3"
	        end

	        describe "after editing the merchant" do
		        before { click_button "Save changes" }
#			        let(:merchant) { Merchant.find_by_name('Example Merchant') }

		        it { should have_selector('title', text: full_title('All Merchants')) }
		        it { should have_selector('div.alert.alert-success', text: 'Merchant updated') }
		    end
	    end
    end

end