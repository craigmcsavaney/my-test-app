require 'spec_helper'

describe "Channel pages" do

    subject { page }

    describe "index" do
    	before do
    		FactoryGirl.create(:channel)
    		visit channels_path
    	end

    	it { should have_h1_title('All Channels') }
    	it { should have_full_title('All Channels') }

    	it "should list each channel" do
    		Channel.all.each do |channel|
    			page.should have_selector('li', text: channel.name)
     			page.should have_selector('li', text: channel.awesm_id)
    			page.should have_selector('li', text: channel.description)
   			end
    	end

    	describe "pagination" do

    		before(:all) { 30.times { FactoryGirl.create(:channel) } }
    		after(:all)  { Channel.delete_all }

    		it { should have_selector('div.pagination') }

    		it "should list each channel" do
    			Channel.paginate(page: 1).each do |channel|
    				page.should have_selector('li', text: channel.name)
     				page.should have_selector('li', text: channel.awesm_id)
    				page.should have_selector('li', text: channel.description)
	   			end
    		end
    	end
    end

    describe "new channel page" do
	    before { visit new_channel_path }

	    it { should have_h1_title('Create Channel') }
	    it { should have_full_title('Create Channel') }

		describe "create channel" do

		    before { visit new_channel_path }

		    let(:submit) { "Create new channel" }

		    describe "with invalid channel name" do
		    	before do
	    			fill_in "Name",				with: " "
	    			fill_in "Awe.SM ID",		with: "Example AweSM ID"

	    		end

		        it "should not create a channel" do
		        	expect { click_button submit }.not_to change(Channel, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_full_title('Create Channel') }
		        	it { should have_an_error_message }
		        end
		    end

		    describe "with invalid awesm_id name" do
		    	before do
	    			fill_in "Name",				with: "Example Name"
	    			fill_in "Awe.SM ID",		with: " "
	    		end

		        it "should not create a channel" do
		        	expect { click_button submit }.not_to change(Channel, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_full_title('Create Channel') }
		        	it { should have_an_error_message }
		        end
		    end

		    describe "with valid information" do
		        before do
		        	fill_in "Name",         	with: "Example Channel"
	    			fill_in "Awe.SM ID",		with: "Example AweSM ID"
		        end

		        it "should create a channel" do
		        	expect { click_button submit }.to change(Channel, :count).by(1)
		        end
		        describe "after creating the channel" do
			        before { click_button submit }
#			        let(:channel) { Channel.find_by_name('Example Channel') }

			        it { should have_full_title('All Channels') }
			        it { should have_this_success_message('New Channel has been created') }
			     end
		    end
		end
    end

    describe "edit" do
	    before do
	    	Channel.delete_all
	    	!FactoryGirl.create(:channel, name: 'Channel1')
	    	!FactoryGirl.create(:channel, name: 'Channel2')
	    	@channel2 = Channel.find_by_name('Channel2') 
	    end

	    before { visit edit_channel_path(@channel2.id) }

	    describe "page" do
		    it { should have_h1_title('Edit Channel') }
		    it { should have_full_title('Edit Channel') }
		    # it { should have_css('Channel2') }  # Can't figure out how to identify this page
		    # # as the exact page I'm looking for, but it clearly is the correct page.
		end

	    describe "with invalid channel name" do
	    	before do
	    		fill_in "Name",				with: " "
	    	end
        	before { click_button "Save changes" }

	        	it { should have_full_title('Edit Channel') }
	        	it { should have_an_error_message }
	    end

	    describe "with invalid awesm_id" do
	    	before do
	    		fill_in "Awe.SM ID",				with: " "
	    	end
        	before { click_button "Save changes" }

	        	it { should have_full_title('Edit Channel') }
	        	it { should have_an_error_message }
	    end

	    describe "with duplicate channel name" do
	    	before do
	    		fill_in "Name",				with: "Channel1"
	    	end
        	before { click_button "Save changes" }

	        	it { should have_full_title('Edit Channel') }
	        	it { should have_an_error_message }
	    end

	    describe "with valid information" do
	    	let(:new_name)  { "Channel3" }
	    	let(:new_awesm_id)  { "Different Example AweSM ID" }
	        before do
	        	fill_in "Name",             with: new_name
	    		fill_in "Awe.SM ID",		with: new_awesm_id
	    		click_button "Save changes"
	        end

	        describe "after editing the channel" do
		        it { should have_full_title('All Channels') }
		        it { should have_this_success_message('Channel updated') }
	        	specify { @channel2.reload.name.should  == new_name }
	        	specify { @channel2.reload.awesm_id.should  == new_awesm_id }
		    end
	    end
    end

end