# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
channel_list = [
  [ "Email", "email", "Shared via email." ],
  [ "Facebook", "facebook", "" ],
  [ "Pinterest", "pinterest", "" ],
  [ "Linkedin", "linkedin", "" ],
  [ "Twitter", "twitter", "Share via standard Twitter tweet" ],
  [ "Purchase", "purchase", "Creates a link to track purchases by an incented buyer" ],
]

puts 'Preparing to create seed Channels'

channel_list.each do |name, awesm_id, description|
  Channel.find_or_create_by_name(name, awesm_id: awesm_id, description: description )
end

puts 'All seed Channels found or created'
