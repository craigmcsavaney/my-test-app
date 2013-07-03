require 'spec_helper'

describe "Promotion pages" do

  subject { page }

  describe "create promotion page" do
    before { visit create_promotion_path }

    it { should have_selector('h1',    text: 'Create Promotion') }
    it { should have_selector('title', text: full_title('Create Promotion')) }
  end
end