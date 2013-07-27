# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Preparing to create seed Settings'

  Setting.find_or_create_by_p_banner_1("Share with your friends and we'll donate 5% to the charity of your choice!",
   facebook_default_msg: "Hi from FB", 
   description: "Click Me", 
   facebook_link_label: "The Caption", 
   banner_template_1: "There are no non-zero contribution percentages - this is currently an invalid promotion and should never happen.", 
   banner_template_2: "Make a purchase and we'll donate _buyer_pct_% of the total to the cause of your choice!", 
   banner_template_3: "Share with your friends and we'll donate _supporter_pct_% to the cause of your choice!", 
   banner_template_4: "Share with your friends and we'll donate _supporter_pct_% to the cause of your choice!", 
   banner_template_5: "Share with your friends and we'll donate _merchant_pct_% of sales to the _cause_!", 
   banner_template_6: "Make a purchase and we'll donate _buyer_pct_% of the total to the cause of your choice, plus we'll donate an additional _merchant_pct_% to the _cause_!", 
   banner_template_7: "Share with your friends and we'll donate _supporter_pct_% to the cause of your choice, plus we'll donate an additional _merchant_pct_% to the _cause_!", 
   banner_template_8: "Share with your friends and we'll donate _supporter_pct_% to the cause of your choice, plus we'll donate an additional _merchant_pct_% to the _cause_!" )

puts 'All seed Settings found or created'
                 
