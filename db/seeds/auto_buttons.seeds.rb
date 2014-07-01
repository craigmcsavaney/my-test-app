# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

auto_button_list = [
  [ "none", "", 0],
  [ "left", "", 1],
  [ "right", "", 2],

]

puts 'Preparing to create seed Auto Button values'

auto_button_list.each do |name, description, order|
  AutoButton.find_or_create_by!(name: name, description: description, order: order )
end

puts 'All seed Auto Button values found or created'

