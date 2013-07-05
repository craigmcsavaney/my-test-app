require 'spec_helper'

describe "Promotion pages" do

  	subject { page }

  	describe "index" do
    	before do
    		Merchant.delete_all
    		@merchant = FactoryGirl.create(:merchant)
    		FactoryGirl.create(:promotion, merchant: @merchant)
    		visit promotions_path
    	end

    	it { should have_selector('h1', text: 'All Promotions') }
    	it { should have_selector('title',    text: full_title('All Promotions')) }

    	it "should list each promotion" do
    		Promotion.all.each do |promotion|
    			page.should have_selector('li', text: promotion.name)
    		end
    	end

    	describe "pagination" do

    		before do
				Merchant.delete_all
    			@merchant = FactoryGirl.create(:merchant)
    			30.times { FactoryGirl.create(:promotion, merchant_id: @merchant.id) }
    			visit promotions_path
    		end
    		# after(:all)  { Promotion.delete_all }

    		it { should have_selector('div.pagination') }

    		it "should list each promotion" do
    			Promotion.paginate(page: 1).each do |promotion|
    				page.should have_selector('li', text: promotion.name)
    			end
    		end
    	end
    end


  	describe "create promotion page" do
    	before do
    		FactoryGirl.create(:merchant, name: 'Example')
			visit create_promotion_path
		end

    	it { should have_selector('h1',    text: 'Create Promotion') }
    	it { should have_selector('title', text: full_title('Create Promotion')) }

		describe "create promotion" do
		    let(:submit) { "Create" }

		    describe "with invalid information" do
		        before do
		        	fill_in "Name",         with: " "
		        end
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
		        	select "Example",		from: "Merchant Name"
		        	select "2013",			from: "promotion_start_date_1i"
		        	select "July",			from: "promotion_start_date_2i"
		        	select "1",				from: "promotion_start_date_3i"
		        	select "2014",			from: "promotion_end_date_1i"
		        	select "July",			from: "promotion_end_date_2i"
		        	select "31",			from: "promotion_end_date_3i"
		        end

		        it "should create a promotion" do
		        	expect { click_button submit }.to change(Promotion, :count).by(1)
		        end
		        describe "after creating the promotion" do
			        before { click_button submit }
#			        let(:merchant) { Merchant.find_by_name('Example Merchant') }

			        it { should have_selector('title', text: full_title('All Promotions')) }
			        it { should have_selector('div.alert.alert-success', text: 'New Promotion has been created') }
			     end
		    end

		    describe "with duplicate merchant name + promotion name" do
		        before do
		        	fill_in "Name",         with: "Example Promotion"
		        	select "Example",		from: "Merchant Name"
		        	select "2013",			from: "promotion_start_date_1i"
		        	select "July",			from: "promotion_start_date_2i"
		        	select "1",				from: "promotion_start_date_3i"
		        	select "2014",			from: "promotion_end_date_1i"
		        	select "July",			from: "promotion_end_date_2i"
		        	select "31",			from: "promotion_end_date_3i"
		        	click_button submit
		        	visit create_promotion_path
		        	fill_in "Name",         with: "Example Promotion"
		        	select "Example",		from: "Merchant Name"
		        	select "2013",			from: "promotion_start_date_1i"
		        	select "July",			from: "promotion_start_date_2i"
		        	select "1",				from: "promotion_start_date_3i"
		        	select "2014",			from: "promotion_end_date_1i"
		        	select "July",			from: "promotion_end_date_2i"
		        	select "31",			from: "promotion_end_date_3i"
		        end
		        it "should not create a promotion" do
		        	expect { click_button submit }.not_to change(Promotion, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_selector('title', text: full_title('Create Promotion')) }
		        	it { should have_content('error') }
		        end
		    end
		end
    end
end