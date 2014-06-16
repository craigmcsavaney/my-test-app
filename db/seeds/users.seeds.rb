# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
after :roles do

puts 'SETTING UP DEFAULT USER LOGIN'
role = Role.find_by_name("SuperAdmin")
user = User.find_or_create_by!(email: 'craigmcsavaney@gmail.com', :password => 'Panthers82', :password_confirmation => 'Panthers82', :role_ids => [role.id] )
puts 'New user created: ' << user.email

 end