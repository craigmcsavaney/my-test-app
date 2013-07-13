require 'spec_helper'

describe "Role pages" do

    subject { page }

    describe "index" do
    	before do
    		FactoryGirl.create(:role)
    		visit roles_path
    	end

    	it { should have_h1_title('All Roles') }
    	it { should have_full_title('All Roles') }

    	it "should list each role" do
    		Role.all.each do |role|
    			page.should have_selector('li', text: role.name)
    			page.should have_selector('li', text: role.description)
   			end
    	end

    	describe "pagination" do

    		before(:all) { 30.times { FactoryGirl.create(:role) } }
    		after(:all)  { Role.delete_all }

    		it { should have_selector('div.pagination') }

    		it "should list each role" do
    			Role.paginate(page: 1).each do |role|
    				page.should have_selector('li', text: role.name)
    				page.should have_selector('li', text: role.description)
	   			end
    		end
    	end
    end

    describe "new role page" do
	    before { visit new_role_path }

	    it { should have_h1_title('Create Role') }
	    it { should have_full_title('Create Role') }

		describe "create role" do

		    before { visit new_role_path }

		    let(:submit) { "Create new role" }

		    describe "with invalid role name" do
		    	before do
	    			fill_in "Name",				with: " "

	    		end

		        it "should not create a role" do
		        	expect { click_button submit }.not_to change(Role, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_full_title('Create Role') }
		        	it { should have_an_error_message }
		        end
		    end

		    describe "with valid information" do
		        before do
		        	fill_in "Name",         	with: "Example Role"
	    			fill_in "Description",		with: "Example Description"
		        end

		        it "should create a role" do
		        	expect { click_button submit }.to change(Role, :count).by(1)
		        end
		        describe "after creating the role" do
			        before { click_button submit }
#			        let(:role) { Role.find_by_name('Example Role') }

			        it { should have_full_title('All Roles') }
			        it { should have_this_success_message('New Role has been created') }
			     end
		    end
		end
    end

    describe "edit" do
	    before do
	    	Role.delete_all
	    	!FactoryGirl.create(:role, name: 'Role1')
	    	!FactoryGirl.create(:role, name: 'Role2')
	    	@role2 = Role.find_by_name('Role2') 
	    end

	    before { visit edit_role_path(@role2.id) }

	    describe "page" do
		    it { should have_h1_title('Edit Role') }
		    it { should have_full_title('Edit Role') }
		    # it { should have_css('Role2') }  # Can't figure out how to identify this page
		    # # as the exact page I'm looking for, but it clearly is the correct page.
		end

	    describe "with invalid role name" do
	    	before do
	    		fill_in "Name",				with: " "
	    	end
        	before { click_button "Save changes" }

	        	it { should have_full_title('Edit Role') }
	        	it { should have_an_error_message }
	    end

	    describe "with duplicate role name" do
	    	before do
	    		fill_in "Name",				with: "Role1"
	    	end
        	before { click_button "Save changes" }

	        	it { should have_full_title('Edit Role') }
	        	it { should have_an_error_message }
	    end

	    describe "with valid information" do
	    	let(:new_name)  { "Role3" }
	    	let(:new_description)  { "Different description" }
	        before do
	        	fill_in "Name",             with: new_name
	    		fill_in "Description",		with: new_description
	    		click_button "Save changes"
	        end

	        describe "after editing the role" do
		        it { should have_full_title('All Roles') }
		        it { should have_this_success_message('Role updated') }
	        	specify { @role2.reload.name.should  == new_name }
	        	specify { @role2.reload.description.should  == new_description }
		    end
	    end
    end

end