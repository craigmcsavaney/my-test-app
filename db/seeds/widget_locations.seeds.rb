# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

widget_locations_list = [
  [ "top-left", "", 0],
  [ "top-center", "", 1],
  [ "top-right", "", 2],
  [ "left-center", "", 3],
  [ "center", "", 4],
  [ "right-center", "", 5],
  [ "bottom-left", "", 6],
  [ "bottom-center", "", 7],
  [ "bottom-right", "", 8],

]

puts 'Preparing to create seed Widget Locations'

widget_locations_list.each do |name, description, order|
  WidgetLocation.find_or_create_by_name( name, description: description, order: order )
end

puts 'All seed Widget Locations found or created'

