# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

roles_list = [
  [ "SuperAdmin", "can manage all resources" ],
  [ "UserAdmin", "can manage all resources owned by all users" ],
  [ "User", "can manage only user-owned resources" ],
  [ "EventAdmin", "can manage Cause Groups and Events" ],

]

puts 'Preparing to create seed Roles'

roles_list.each do |name, description|
  Role.find_or_create_by_name( name, description: description )
end

puts 'All seed Roles found or created'

