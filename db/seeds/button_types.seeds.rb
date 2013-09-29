# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

button_types_list = [
  [ "Image", "Button is an image file" ],
  [ "CSS", "Button is constructed from CSS" ],

]

puts 'Preparing to create seed Button Types'

button_types_list.each do |name, description|
  ButtonType.find_or_create_by_name( name, description: description )
end

puts 'All seed Button Types found or created'

