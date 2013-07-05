require 'spec_helper'

describe "Cause pages" do

    subject { page }

    describe "index" do
    	before do
    		FactoryGirl.create(:cause)
    		visit causes_path
    	end

    	it { should have_selector('h1', text: 'All Causes') }
    	it { should have_selector('title',    text: full_title('All Causes')) }

    	it "should list each cause" do
    		Cause.all.each do |cause|
    			page.should have_selector('li', text: cause.name)
    		end
    	end

    	describe "pagination" do

    		before(:all) { 30.times { FactoryGirl.create(:cause) } }
    		after(:all)  { Cause.delete_all }

    		it { should have_selector('div.pagination') }

    		it "should list each cause" do
    			Cause.paginate(page: 1).each do |cause|
    				page.should have_selector('li', text: cause.name)
    			end
    		end
    	end
    end

    describe "new cause page" do
	    before { visit new_cause_path }

	    it { should have_selector('h1',    text: 'Create Cause') }
	    it { should have_selector('title', text: full_title('Create Cause')) }

		describe "create cause" do

		    before { visit new_cause_path }

		    let(:submit) { "Create new cause" }

		    describe "with invalid information" do
		        it "should not create a cause" do
		        	expect { click_button submit }.not_to change(Cause, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_selector('title', text: 'Create Cause') }
		        	it { should have_content('error') }
		        end
		    end

		    describe "with valid information" do
		        before do
		        	fill_in "Name",         with: "Example Cause"
		        end

		        it "should create a cause" do
		        	expect { click_button submit }.to change(Cause, :count).by(1)
		        end
		        describe "after creating the cause" do
			        before { click_button submit }
#			        let(:cause) { Cause.find_by_name('Example Cause') }

			        it { should have_selector('title', text: full_title('All Causes')) }
			        it { should have_selector('div.alert.alert-success', text: 'New Cause has been created') }
			     end
		    end
		end
    end

    describe "edit" do
	    before do
	    	Cause.delete_all
	    	!FactoryGirl.create(:cause, name: 'Cause1')
	    	!FactoryGirl.create(:cause, name: 'Cause2')
	    	@cause2 = Cause.find_by_name('Cause2') 
	    end

	    before { visit edit_cause_path(@cause2.id) }

	    describe "page" do
		    it { should have_selector('h1',    text: 'Edit Cause') }
		    it { should have_selector('title', text: full_title('Edit Cause')) }
		    # it { should have_css('Cause2') }  # Can't figure out how to identify this page
		    # # as the exact page I'm looking for, but it clearly is the correct page.
		end

	    describe "with invalid cause name" do
	    	before do
	    		fill_in "Name",				with: " "
	    	end
        	before { click_button "Save changes" }

	        	it { should have_selector('title', text: full_title('Edit Cause')) }
	        	it { should have_content('error') }
	    end

	    describe "with duplicate cause name" do
	    	before do
	    		fill_in "Name",				with: "Cause1"
	    	end
        	before { click_button "Save changes" }

	        	it { should have_selector('title', text: full_title('Edit Cause')) }
	        	it { should have_content('error') }
	    end

	    describe "with valid information" do
	        before do
	        	fill_in "Name",         with: "Cause3"
	        end

	        describe "after editing the cause" do
		        before { click_button "Save changes" }
#			        let(:cause) { Cause.find_by_name('Example Cause') }

		        it { should have_selector('title', text: full_title('All Causes')) }
		        it { should have_selector('div.alert.alert-success', text: 'Cause updated') }
		    end
	    end
    end

end