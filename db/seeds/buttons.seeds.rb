# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

after :button_types do

puts 'Preparing to create seed Buttons'

  	Button.find_or_create_by!(name: "No button (we'll add a button graphic ourselves)", description: "No button will be inserted. Merchant must provide its own button with the appropriate attributes.", button_type_id: ButtonType.find_by_name("CSS").id )
	Button.find_or_create_by!(name: "Basic", description: "Basic CSS button", button_type_id: ButtonType.find_by_name("CSS").id )

puts 'All seed Buttons found or created'

end
