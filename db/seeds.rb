# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
channel_list = [
  [ "Email", "email", "Shared via email." ],
  [ "Facebook Share", "facebook-share", "" ],
  [ "Facebook Post", "facebook-post", "" ],
  [ "Facebook Send", "facebook-send", "" ],
  [ "LinkedIn", "linkedin-share", "" ],
  [ "Tumbler", "tumblr-link", "" ],
  [ "Twitter", "twitter", "Share via standard Twitter tweet" ],
  [ "Google Plus", "googleplus", "Share via Google+" ],
]

channel_list.each do |name, awesm_id, description|
  Channel.create( name: name, awesm_id: awesm_id, description: description )
end

roles_list = [
  [ "SuperAdmin", "can manage all resources" ],
  [ "UserAdmin", "can manage all resources owned by all users" ],
  [ "User", "can manage only user-owned resources" ],

]

roles_list.each do |name, description|
  Role.create( name: name, description: description )
end

puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :email => 'craigmcsavaney@gmail.com', :password => 'Panthers82', :password_confirmation => 'Panthers82', :role_ids => [1]
puts 'New user created: ' << user.email