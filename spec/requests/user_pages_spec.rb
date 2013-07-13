require 'spec_helper'

describe "User pages" do

  	subject { page }

  	describe "signup page" do
    	before { visit new_user_registration_path }

    	it { should have_h1_title('Sign up') }
    	it { should have_full_title('Sign up') }
  
		describe "sign up new user" do

		    # before { visit new_cause_path }

		    let(:submit) { "Sign up" }

		    describe "with blank email" do
		        before do
		        	fill_in "Password",					with: "12345678"
		        	fill_in "Password confirmation",	with: "12345678"
		        end
		        it "should not create a user" do
		        	expect { click_button submit }.not_to change(User, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_full_title('Sign up') }
		        	it { should have_an_error_message }
		        end
		    end

		    describe "with invalid email" do
		        before do
		        	fill_in "Email",         			with: "Example"
		        	fill_in "Password",					with: "12345678"
		        	fill_in "Password confirmation",	with: "12345678"
		        end
		        it "should not create a user" do
		        	expect { click_button submit }.not_to change(User, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_full_title('Sign up') }
		        	it { should have_an_error_message }
		        end
		    end

		    describe "with invalid email" do
		        before do
		        	fill_in "Email",         			with: "Example@example"
		        	fill_in "Password",					with: "12345678"
		        	fill_in "Password confirmation",	with: "12345678"
		        end
		        it "should not create a user" do
		        	expect { click_button submit }.not_to change(User, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_full_title('Sign up') }
		        	it { should have_an_error_message }
		        end
		    end

		    describe "with invalid passwords" do
		        before do
		        	fill_in "Email",         			with: "Example@example.com"
		        	fill_in "Password",					with: "1234567"
		        	fill_in "Password confirmation",	with: "1234567"
		        end
		        it "should not create a user" do
		        	expect { click_button submit }.not_to change(User, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_full_title('Sign up') }
		        	it { should have_an_error_message }
		        end
		    end

		    describe "with mismatchesdpasswords" do
		        before do
		        	fill_in "Email",         			with: "Example@example.com"
		        	fill_in "Password",					with: "12345678"
		        	fill_in "Password confirmation",	with: "12345679"
		        end
		        it "should not create a user" do
		        	expect { click_button submit }.not_to change(User, :count)
		        end
		        describe "after submission" do
		        	before { click_button submit }

		        	it { should have_full_title('Sign up') }
		        	it { should have_an_error_message }
		        end
		    end


		    describe "with valid information" do
		        before do
		        	fill_in "Email",         			with: "Example@example.com"
		        	fill_in "Password",					with: "12345678"
		        	fill_in "Password confirmation",	with: "12345678"
		        end

		        it "should create a user" do
		        	expect { click_button submit }.to change(User, :count).by(1)
		        end
		        describe "after creating the user" do
			        before { click_button submit }

			        it { should have_full_title('Home') }
			        it { should have_this_notice_message('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.') }
			     end
		    end
		end
  	end

  	describe "index" do
    	before do
    		FactoryGirl.create(:user_with_roles)
    		visit users_path
    	end

    	it { should have_h1_title('All Users') }
    	it { should have_full_title('All Users') }

    	it "should list each user" do
    		User.all.each do |user|
    			page.should have_selector('li', text: user.email)
    		end
    	end

    	describe "pagination" do

    		before do
    			30.times { FactoryGirl.create(:user_with_roles) }
    			visit users_path
    		end

    		it { should have_selector('div.pagination') }

    		it "should list each user" do
    			User.paginate(page: 1).each do |user|
    				page.should have_selector('li', text: user.email)
    			end
    		end
    	end
    end

    describe "edit" do
	    before do
	    	User.delete_all
    		@user1 = FactoryGirl.create(:user_with_roles)
    		@user2 = FactoryGirl.create(:user_with_roles)
	    end

	    before { visit edit_user_path(@user1.id) }

	    describe "page" do
		    it { should have_h1_title('Edit User') }
		    it { should have_full_title('Edit User') }
		    # it { should have_css('Merchant2') }  # Can't figure out how to identify this page
		    # # as the exact page I'm looking for, but it clearly is the correct page.
		end

		describe "with valid role changes" do
	        before do
	        	uncheck('user_role_ids_')
	        end

	        it "should change user roles" do
	        	expect { click_button "Save changes" }.to change(@user1.roles, :count).by(-1)
	        end
	        describe "after changing the user roles" do
		        before { click_button "Save changes" }

		        it { should have_full_title('All Users') }
		        it { should have_this_success_message('User updated') }
		     end
	    end
    end

end