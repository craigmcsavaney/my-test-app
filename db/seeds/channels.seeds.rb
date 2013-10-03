# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
channel_list = [
  [ "GooglePlus", "googleplus", "", true, true, "https://plus.google.com/share?url=" ],
  [ "Facebook", "facebook", "", true, true, "https://www.facebook.com/dialog/feed?link=" ],
  [ "Pinterest", "pinterest", "", true, true, "http://pinterest.com/pin/create/button/?url=" ],
  [ "Linkedin", "linkedin", "", true, true, "https://www.linkedin.com/cws/share?url=" ],
  [ "Twitter", "twitter", "Share via standard Twitter tweet", true, true, "https://twitter.com/intent/tweet?url=" ],
  [ "Purchase", "purchase", "Creates a link to track purchases by an incented buyer", false, true, "" ],
]

puts 'Preparing to create seed Channels'

channel_list.each do |name, awesm_id, description, visible, active, url_prefix|
  Channel.find_or_create_by_name(name, awesm_id: awesm_id, description: description, visible: visible, active: active, url_prefix: url_prefix )
end

puts 'All seed Channels found or created'
