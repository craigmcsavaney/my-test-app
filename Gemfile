source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'bootstrap-sass', '2.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'cancan', '1.6.10'
gem 'vestal_versions', :git => 'git://github.com/laserlemon/vestal_versions'
gem 'amoeba', '2.0.0'
gem 'devise', '3.0.0'
# gem 'devise', '3.1.1'
gem 'seedbank', github: 'james2m/seedbank'
gem 'rabl', '0.8.6'
gem 'oj', '2.1.4'
gem 'awesm', '0.1.10'
gem 'money-rails', '0.8.1'
gem "select2-rails", "~> 3.5.0"
gem 'devise_invitable', '1.1.8'
# gem 'devise_invitable', '1.3.0'

#added following require and gem for Guard compatibility with wdm
require 'rbconfig'
gem 'wdm', '>= 0.1.0' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i


group :development do
	gem 'mysql2', '0.3.11'
	gem 'guard-rspec', '1.2.1'
  gem 'annotate', '2.5.0'
end

group :development, :test do
  gem 'rspec-rails', '2.11.0'
  gem 'guard-spork', '1.2.0'
  gem 'childprocess', '0.3.9'
  gem 'spork', '0.9.2'
  gem 'rails-erd'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

gem 'jquery-rails', '2.0.2'

group :test do
	gem 'capybara', '1.1.2'
  gem 'rb-fchange', '0.0.5'
  gem 'rb-notifu', '0.0.4'
  gem 'win32console', '1.3.0'
  gem 'factory_girl_rails', '4.1.0'
  gem 'email_spec'
end

group :production do
	gem 'pg', '0.12.2'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
