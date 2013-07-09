include ApplicationHelper

RSpec::Matchers.define :have_this_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_an_error_message do
  match do |page|
    page.should have_content('error')
  end
end

RSpec::Matchers.define :have_this_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message) 
  end
end

RSpec::Matchers.define :have_full_title do |title|
  match do |page|
    page.should have_selector('title', text: full_title(title)) 
  end
end

RSpec::Matchers.define :have_h1_title do |title|
  match do |page|
    page.should have_selector('h1', text: title) 
  end
end