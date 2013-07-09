require 'spec_helper'

describe "StaticPages" do

  subject { page }

    shared_examples_for "all static pages" do
      it { should have_h1_title(heading) }
      it { should have_full_title(page_title) }
    end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    page.should have_full_title('')
    #test header links
    click_link "About Us"
    page.should have_full_title('About Us')
    click_link "Help"
    page.should have_full_title('Help')
    click_link "Contact"
    page.should have_full_title('Contact')
    #click_link "Sign Up"
    #page.should have_selector 'title', text: full_title('Sign Up')
    #now test footer links not in header
    click_link "About"
    page.should have_full_title('About Us')
    click_link "Home"
    page.should have_full_title('')
    #click_link "Sign up now!"
    #page.should # fill in
    #click_link "sample app"
    #page.should # fill in
  end

end
