source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '~>4.0.0'
gem 'bootstrap-sass'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'cancan', '1.6.10'
gem 'vestal_versions', :git => 'git://github.com/laserlemon/vestal_versions'
gem 'amoeba', '2.0.0'
gem 'devise', '3.2.4'
# gem 'devise', '3.1.1'
gem 'seedbank', github: 'james2m/seedbank'
gem 'rabl', '0.8.6'
gem 'oj', '2.1.4'
gem 'awesm', '0.1.10'
gem 'money-rails', '0.8.1'
gem "select2-rails", "~> 3.5.0"
# gem 'devise_invitable', '1.3.2'
gem 'devise_invitable', '1.3.5'
gem 'rest-client', :require => 'rest-client'
gem 'font-awesome-sass'
gem 'activerecord-tableless', '~> 1.0'
gem "recaptcha", :require => "recaptcha/rails"

# rails 4 upgrade gem:
gem 'rails4_upgrade'
# following three moved as part of 4.0 upgrade
gem 'sass-rails', '~>4.0.0'
gem 'coffee-rails', '~>4.0.0'
gem 'uglifier', '>=1.3.0'
# added as part of 4.0 upgrade:
gem 'actionpack-action_caching', '~>1.0.0'
gem 'actionpack-page_caching', '~>1.0.0'
gem 'actionpack-xml_parser', '~>1.0.0'
gem 'actionview-encoded_mail_to', '~>1.0.4'
#gem 'activerecord-session_store', '~>0.0.1'
gem 'activerecord-session_store', '>=0.1.0'
#gem 'activeresource', '~>4.0.0.beta1'
gem 'activeresource', '>=4.0.0'
gem 'protected_attributes', '~>1.0.1'
gem 'rails-observers', '~>0.1.1'
gem 'rails-perftest', '~>0.0.2'
gem 'sprockets_better_errors'
gem 'sprockets-rails', '~>2.0.0'
gem 'activerecord', '<5', '>=4.0.0'

# Following gem added because this is the version Devise 3.2.2 needs at the moment:
#gem 'activesupport', '4.0.2'
gem 'activesupport', '~>4.0.2'

#added following require and gem for Guard compatibility with wdm
require 'rbconfig'
gem 'wdm', '>= 0.1.0' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i


group :development do
  gem 'mysql2', '0.3.11'
  gem 'guard-rspec', '1.2.1'
  gem 'annotate', '2.5.0'
end

group :development, :test do
  gem 'rspec-rails', '>= 2.13.2'
  gem 'guard-spork', '1.2.0'
  gem 'childprocess', '0.3.9'
  gem 'spork', '0.9.2'
  gem 'rails-erd'
end

# Delete `group :assets` and move these gems
# (and any others) to the top level as part of upgrade to rails 4.0
# # Gems used only for assets and not required
# # in production environments by default.
# group :assets do
#   gem 'sass-rails',   '3.2.5'
#   gem 'coffee-rails', '3.2.2'
#   gem 'uglifier', '1.2.3'
# end

gem 'jquery-rails', '2.0.2'

group :test do
  gem 'capybara', '1.1.2'
  gem 'rb-fchange', '0.0.5'
  gem 'rb-notifu', '0.0.4'
  gem 'win32console', '1.3.0'
  gem 'factory_girl_rails', '4.1.0'
  gem 'email_spec'
end

group :production, :staging do
  gem 'pg'
  gem 'rails_12factor'
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
