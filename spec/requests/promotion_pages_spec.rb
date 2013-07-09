require 'spec_helper'

describe "Promotion pages" do

  	subject { page }

  	describe "index" do
    	before do
    		Merchant.delete_all
    		@merchant = FactoryGirl.create(:merchant)
    		FactoryGirl.create(:promotion_with_channels, merchant: @merchant)
    		visit promotions_path
    	end

    	it { should have_h1_title('All Promotions') }
    	it { should have_full_title('All Promotions') }

    	it "should list each promotion" do
    		Promotion.all.each do |promotion|
    			page.should have_selector('li', text: promotion.name)
    		end
    	end

    	describe "pagination" do

    		before do
				Merchant.delete_all
    			@merchant = FactoryGirl.create(:merchant)
    			30.times { FactoryGirl.create(:promotion_with_channels, merchant_id: @merchant.id) }
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
    		10.times { FactoryGirl.create(:channel) }
			visit create_promotion_path
		end

    	it { should have_h1_title('Create Promotion') }
    	it { should have_full_title('Create Promotion') }
    	it { should have_selector('label', text: 'Selected Channels') }

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

		        	it { should have_full_title('Create Promotion') }
		        	it { should have_an_error_message }
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
		        	check('promotion_channel_ids_')
		        end

		        it "should create a promotion" do
		        	expect { click_button submit }.to change(Promotion, :count).by(1)
		        end
		        describe "after creating the promotion" do
			        before { click_button submit }
#			        let(:merchant) { Merchant.find_by_name('Example Merchant') }

			        it { should have_full_title('All Promotions') }
			        it { should have_this_success_message('New Promotion has been created') }
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

		        	it { should have_full_title('Create Promotion') }
		        	it { should have_an_error_message }
		        end
		    end
		end
    end

    describe "edit" do
	    before do
	    	Promotion.delete_all
	    	@merchant1 = FactoryGirl.create(:merchant)
    		@promotion1 = FactoryGirl.create(:promotion, merchant: @merchant1)
    		@promotion2 = FactoryGirl.create(:promotion, merchant: @merchant1)
	    end

	    before { visit edit_promotion_path(@promotion1.id) }

	    describe "page" do
		    it { should have_h1_title('Edit Promotion') }
		    it { should have_full_title('Edit Promotion') }
		    # it { should have_css('Merchant2') }  # Can't figure out how to identify this page
		    # # as the exact page I'm looking for, but it clearly is the correct page.
		end

	    describe "with invalid promotion name" do
	    	before do
	    		fill_in "Name",				with: " "
	    		click_button "Save changes"
	    	end
        	it { should have_full_title('Edit Promotion') }
        	it { should have_an_error_message }
	    end

	    describe "with duplicate promotion name" do
	    	before do
	    		fill_in "Name",				with: @promotion2.name
	    		click_button "Save changes"
	    	end
        	it { should have_full_title('Edit Promotion') }
        	it { should have_an_error_message }
	    end

	    describe "with valid information" do
	    	let(:new_name)  { "Example Promotion3" }
	    	let(:new_content) { "new content"}
	        before do
	        	fill_in "Promotion Name",	with: new_name
	        	fill_in "Content",			with: new_content
	        	click_button "Save changes"
	        end
	        it { should have_full_title('All Promotions') }
	        it { should have_this_success_message('Promotion updated') }
	        specify { @promotion1.reload.name.should  == new_name }
	        specify { @promotion1.reload.content.should  == new_content }
	    end
    end
end